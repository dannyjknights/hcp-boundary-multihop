resource "vault_token" "boundary_vault_token" {
  policies  = ["boundary-controller", "kv-read"]
  no_parent = true
  renewable = true
  ttl       = "24h"
  period    = "24h"
}

resource "boundary_credential_store_vault" "vault_cred_store" {
  name        = "boudary-vault-credential-store"
  description = "Vault Credential Store"
  address     = var.vault_addr
  token       = vault_token.boundary_vault_token.client_token
  namespace   = "admin"
  scope_id    = boundary_scope.project.id

  depends_on = [vault_token.boundary_vault_token]
}

resource "boundary_credential_library_vault" "vault_cred_lib" {
  name                = "boundary-vault-credential-library"
  description         = "Vault SSH private key credential"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "kv/data/credentials/ssh"
  http_method         = "GET"
  credential_type     = "username_password"
  //credential_type = "ssh_private_key"
}