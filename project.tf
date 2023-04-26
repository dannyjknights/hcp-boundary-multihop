resource "boundary_scope" "project" {
  name        = "Ops_Tests"
  description = "Manage Prod Resources"

  # scope_id is taken from the org resource defined for 'Ops'
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}
