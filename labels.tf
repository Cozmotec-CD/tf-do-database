##Description : This Script is used to create VPC.
#Module      : LABEL
#Description : Terraform label module variables.
module "labels" {
  source      = "git@github.com:dumberdore/tf-do-labels"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}