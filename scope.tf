resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "ops-org"
  description              = "Support Ops Team"
  auto_create_default_role = true
  auto_create_admin_role   = true
}
