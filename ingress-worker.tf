resource "boundary_worker" "ingress_pki_worker" {
  scope_id                    = "global"
  name                        = "bounday-ingress-pki-worker"
  worker_generated_auth_token = ""
}

locals {
  boundary_ingress_worker_service_config = <<-WORKER_SERVICE_CONFIG
  [Unit]
  Description="HashiCorp Boundary - Identity-based access management for dynamic infrastructure"
  Documentation=https://www.boundaryproject.io/docs
  #StartLimitIntervalSec=60
  #StartLimitBurst=3

  [Service]
  EnvironmentFile=-/etc/boundary.d/boundary.env
  User=boundary
  Group=boundary
  ProtectSystem=full
  ProtectHome=read-only
  ExecStart=/usr/bin/boundary-worker server -config=/etc/boundary.d/pki-worker.hcl
  ExecReload=/bin/kill --signal HUP $MAINPID
  KillMode=process
  KillSignal=SIGINT
  Restart=on-failure
  RestartSec=5
  TimeoutStopSec=30
  LimitMEMLOCK=infinity

  [Install]
  WantedBy=multi-user.target
  WORKER_SERVICE_CONFIG

  boundary_ingress_worker_hcl_config = <<-WORKER_HCL_CONFIG
  disable_mlock = true

  hcp_boundary_cluster_id = "${split(".", split("//", var.boundary_addr)[1])[0]}"

  listener "tcp" {
    address = "0.0.0.0:9202"
    purpose = "proxy"
  }

  worker {
    public_addr = "file:///tmp/ip"
    auth_storage_path = "/etc/boundary.d/worker"
    controller_generated_activation_token = "${boundary_worker.ingress_pki_worker.controller_generated_activation_token}"
    tags {
      type = ["sm-ingress-upstream-worker1", "upstream"]
    }
  }
WORKER_HCL_CONFIG

  cloudinit_config_boundary_ingress_worker = {
    write_files = [
      {
        content = local.boundary_ingress_worker_service_config
        path    = "/usr/lib/systemd/system/boundary.service"
      },

      {
        content = local.boundary_ingress_worker_hcl_config
        path    = "/etc/boundary.d/pki-worker.hcl"
      },
    ]
  }
}

data "cloudinit_config" "boundary_ingress_worker" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
      sudo yum -y install boundary-worker-hcp
      curl 'https://api.ipify.org?format=txt' > /tmp/ip
  EOF
  }
  part {
    content_type = "text/cloud-config"
    content      = yamlencode(local.cloudinit_config_boundary_ingress_worker)
  }
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    sudo boundary-worker server -config="/etc/boundary.d/pki-worker.hcl"
    EOF
  }
}

resource "aws_instance" "boundary_ingress_worker" {
  ami                         = "ami-09ee0944866c73f62"
  instance_type               = "t2.micro"
  availability_zone           = "eu-west-2b"
  user_data_replace_on_change = true
  user_data_base64            = data.cloudinit_config.boundary_ingress_worker.rendered
  key_name                    = "boundary"
  private_ip                  = "172.31.32.93"
  subnet_id                   = aws_subnet.boundary_ingress_worker_subnet.id
  vpc_security_group_ids      = [aws_security_group.boundary_ingress_worker_ssh.id]
  tags = {
    Name = "Boundary Ingress Worker"
  }
  depends_on = [
    aws_nat_gateway.nat_gateway, boundary_worker.ingress_pki_worker
  ]
}