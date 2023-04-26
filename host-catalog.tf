resource "boundary_host_catalog_static" "devops" {
  name        = "DevOps"
  description = "For DevOps Team"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "amazon_public_linux" {
  name            = "aws-public-linux"
  description     = "AWS Linux host"
  address         = aws_instance.boundary_public_target.public_ip
  host_catalog_id = boundary_host_catalog_static.devops.id
}

resource "boundary_host_static" "amazon_private_linux" {
  name            = "aws-private-linux"
  description     = "AWS Linux host"
  address         = aws_instance.boundary_target.private_ip
  host_catalog_id = boundary_host_catalog_static.devops.id
}

resource "boundary_host_catalog_plugin" "aws_plugin" {
  name        = "AWS Catalog"
  description = "AWS Host Catalog"
  scope_id    = boundary_scope.project.id
  plugin_name = "aws"
  attributes_json = jsonencode({
    "region" = "eu-west-2",
  "disable_credential_rotation" = true })


  secrets_json = jsonencode({
    "access_key_id"     = var.aws_access,
    "secret_access_key" = var.aws_secret
  })

}
