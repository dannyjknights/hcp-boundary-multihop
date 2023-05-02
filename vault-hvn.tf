# Work in progress to create the HVN for HashiCorp Vault
resource "hcp_hvn" "hcp_vault_hvn" {
  hvn_id         = "hcp-vault-hvn"
  cloud_provider = "aws"
  region         = "eu-west-2"
  cidr_block     = "10.0.0.0/24"
}

resource "aws_ram_resource_share" "hcp_hvn_ram" {
  name                      = "hcp-hvn-ram"
  allow_external_principals = true
}

resource "aws_ram_principal_association" "hcp_hvn_principal_association" {
  resource_share_arn = aws_ram_resource_share.hcp_hvn_ram.arn
  principal          = hcp_hvn.hcp_vault_hvn.provider_account_id
}

resource "aws_ram_resource_association" "hcp_hvn_resource_association" {
  resource_share_arn = aws_ram_resource_share.hcp_hvn_ram.arn
  resource_arn       = aws_ec2_transit_gateway.boundary_tgw.arn
}

resource "hcp_aws_transit_gateway_attachment" "hcp_tgw_attachment" {
  hvn_id                        = hcp_hvn.hcp_vault_hvn.hvn_id
  transit_gateway_attachment_id = "hcp-vault-tgw-attachment"
  transit_gateway_id            = aws_ec2_transit_gateway.boundary_tgw.id
  resource_share_arn            = aws_ram_resource_share.hcp_hvn_ram.arn

  depends_on = [
    aws_ram_principal_association.hcp_hvn_principal_association,
    aws_ram_resource_association.hcp_hvn_resource_association,
  ]
}

resource "hcp_hvn_route" "hcp_hvn_tgw_route" {
  hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
  hvn_route_id     = "hvn-to-tgw-attachment"
  destination_cidr = aws_vpc.boundary_ingress_worker_vpc.cidr_block
  target_link      = hcp_aws_transit_gateway_attachment.hcp_tgw_attachment.self_link
}