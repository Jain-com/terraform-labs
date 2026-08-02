# Terraform Workspaces Cheat Sheet

Terraform Workspaces allow you to manage multiple isolated instances of state data within a single configuration directory. They are ideal for separating environments (such as `dev`, `stage`, and `prod`) without duplicating code.

---

## Workspace Command Reference

### 1. `terraform workspace list`
Lists all available workspaces in the current Terraform directory.
Highlights the currently active workspace with an asterisk (`*`).

### 2. `terraform workspace show`
Displays the name of the currently active workspace.
Useful in scripts or quick checks to ensure you are modifying the intended environment.

### 3. `terraform workspace new <WORKSPACE_NAME>`
Creates a new workspace with the specified name and immediately switches to it.
Generates an isolated state file associated with the newly created workspace.

### 4. `terraform workspace select <WORKSPACE_NAME>`
Switches your current context to an existing workspace by name.
All subsequent `terraform plan` or `terraform apply` commands will target this workspace's state.

### 5. `terraform workspace delete <WORKSPACE_NAME>`
Deletes an existing workspace and its associated state file from storage.
You cannot delete the currently active workspace or a workspace that still manages active resources.

---

## Workspace Variables in HCL

Inside your `.tf` files, you can dynamically reference the active workspace using the built-in variable:

hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-app-bucket-${terraform.workspace}"
}