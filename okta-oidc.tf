resource "boundary_auth_method_oidc" "provider" {
  name                 = "Okta"
  description          = "OIDC auth method for Okta"
  scope_id             = "global"
  issuer               = var.okta_issuer
  client_id            = var.okta_client_id
  client_secret        = var.okta_client_secret
  signing_algorithms   = ["RS256"]
  api_url_prefix       = var.okta_api_url
  is_primary_for_scope = true
  state                = "active-public"
  max_age              = 0
}

resource "boundary_account_oidc" "oidc_user" {
  name           = "danny-hashicorp"
  description    = "OIDC account for Danny-HashiCorp"
  auth_method_id = boundary_auth_method_oidc.provider.id
  issuer         = var.okta_issuer
  subject        = var.okta_client_id
}

resource "boundary_managed_group" "oidc_managed_group" {
  name           = "okta-managed-group"
  description    = "Okta Managed Group"
  auth_method_id = boundary_auth_method_oidc.provider.id
  filter         = "\"okta.com\" in \"/token/iss\""
}

resource "boundary_role" "oidc_admin_role" {
  name          = "Admin Role"
  description   = "admin role"
  principal_ids = [boundary_managed_group.oidc_managed_group.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.global.id
}


resource "boundary_role" "oidc_user_role" {
  name          = "User Role"
  description   = "user role"
  principal_ids = [boundary_managed_group.oidc_managed_group.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.org.id
}