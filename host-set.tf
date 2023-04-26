resource "boundary_host_set_static" "aws-linux-machines" {
  name            = "aws-linux-machines"
  description     = "Host set for AWS Linux Machines"
  host_catalog_id = boundary_host_catalog_static.devops.id
  host_ids = [
    boundary_host_static.amazon_public_linux.id,
    boundary_host_static.amazon_private_linux.id,
  ]
}

resource "boundary_host_set_plugin" "aws-db" {
  name                  = "AWS DB Host Set Plugin"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:18.170.24.32/32"]
  attributes_json       = jsonencode({ "filters" = "tag:service-type=database" })
  sync_interval_seconds = 30
}

resource "boundary_host_set_plugin" "aws-dev" {
  name                  = "AWS Dev Host Set Plugin"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:0.0.0.0/0"]
  attributes_json       = jsonencode({ "filters" = "tag:application=dev" })
  sync_interval_seconds = 30
}

resource "boundary_host_set_plugin" "aws-prod" {
  name                  = "AWS Prod Host Set Plugin"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:0.0.0.0/0"]
  attributes_json       = jsonencode({ "filters" = "tag:application=production" })
  sync_interval_seconds = 30
}
