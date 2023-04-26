resource "boundary_target" "aws_linux_private" {
  type                     = "tcp"
  name                     = "aws-private-linux"
  description              = "AWS Linux Private Target"
  egress_worker_filter     = " \"sm-egress-downstream-worker1\" in \"/tags/type\" "
  ingress_worker_filter    = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.aws-linux-machines.id
  ]
}

resource "boundary_target" "aws_linux_public" {
  type                     = "tcp"
  name                     = "aws-public-linux"
  description              = "AWS Linux Public Target"
  egress_worker_filter     = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.aws-linux-machines.id
  ]
}

resource "boundary_target" "aws" {
  type                     = "tcp"
  name                     = "aws-ec2"
  description              = "AWS EC2 Targets"
  egress_worker_filter     = " \"sm-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_plugin.aws-db.id,
    boundary_host_set_plugin.aws-dev.id,
    boundary_host_set_plugin.aws-prod.id,
  ]
}