# # Work in progress to create the HVN for HashiCorp Vault
# resource "hcp_hvn" "hcp_vault_hvn" {
#   hvn_id         = "hcp-vault-hvn"
#   cloud_provider = "aws"
#   region         = "eu-west-2"
#   cidr_block     = "10.0.0.0/24"
# }

# resource "aws_vpc" "peer_to_vpc" {
#   cidr_block = "172.31.0.0/16"
# }

# data "aws_arn" "peer" {
#   arn = aws_vpc.peer_to_vpc.arn
# }

# resource "hcp_aws_network_peering" "hcp_network_peering" {
#   hvn_id          = hcp_hvn.hcp_vault_hvn.hvn_id
#   peering_id      = "hvn-peering"
#   peer_vpc_id     = aws_vpc.peer_to_vpc.id
#   peer_account_id = aws_vpc.peer_to_vpc.owner_id
#   peer_vpc_region = data.aws_arn.peer.region
# }

# resource "hcp_hvn_route" "hcp_hvn_peering_route" {
#   hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
#   hvn_route_id     = "hvn-peering-attachment"
#   destination_cidr = "172.31.0.0/16"
#   target_link      = hcp_aws_network_peering.hcp_network_peering.self_link
# }

# resource "aws_vpc_peering_connection_accepter" "peering_accepter" {
#   vpc_peering_connection_id = hcp_aws_network_peering.hcp_network_peering.provider_peering_id
#   auto_accept               = true
# }

# # resource "aws_ram_resource_share" "hcp_hvn_ram" {
# #   name                      = "hcp-hvn-ram"
# #   allow_external_principals = true
# # }

# # resource "aws_ram_principal_association" "hcp_hvn_principal_association" {
# #   resource_share_arn = aws_ram_resource_share.hcp_hvn_ram.arn
# #   principal          = hcp_hvn.hcp_vault_hvn.provider_account_id
# # }

# # resource "aws_ram_resource_association" "hcp_hvn_resource_association" {
# #   resource_share_arn = aws_ram_resource_share.hcp_hvn_ram.arn
# #   resource_arn       = aws_ec2_transit_gateway.boundary_tgw.arn
# # }

# # resource "hcp_aws_transit_gateway_attachment" "hcp_tgw_attachment" {
# #   hvn_id                        = hcp_hvn.hcp_vault_hvn.hvn_id
# #   transit_gateway_attachment_id = "hcp-vault-tgw-attachment"
# #   transit_gateway_id            = aws_ec2_transit_gateway.boundary_tgw.id
# #   resource_share_arn            = aws_ram_resource_share.hcp_hvn_ram.arn

# #   depends_on = [
# #     aws_ram_principal_association.hcp_hvn_principal_association,
# #     aws_ram_resource_association.hcp_hvn_resource_association,
# #   ]
# # }

# # resource "hcp_hvn_route" "hcp_hvn_tgw_route" {
# #   hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
# #   hvn_route_id     = "hvn-to-tgw-attachment"
# #   destination_cidr = aws_vpc.boundary_ingress_worker_vpc.cidr_block
# #   target_link      = hcp_aws_transit_gateway_attachment.hcp_tgw_attachment.self_link
# # }