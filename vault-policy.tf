resource "vault_policy" "boundary_controller_policy" {
  name   = "boundary-controller"
  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_policy" "kv-policy" {
  name   = "kv-read"
  policy = <<EOT
path "credential/ssh" {
  capabilities = ["read"]
}
EOT
}