# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Local tag and naming rules shared by Terraform environment roots.

locals {
  name_prefix = "${var.project}-${var.environment}"

  required_tags = {
    application         = var.project
    environment         = var.environment
    owner               = var.owner
    cost-center         = var.cost_center
    managed-by          = "terraform"
    data-classification = var.data_classification
  }
}
