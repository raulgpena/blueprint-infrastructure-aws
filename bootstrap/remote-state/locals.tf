# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Local naming and tagging values used by the remote state bootstrap stack.

locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = {
    application         = var.project
    environment         = var.environment
    owner               = var.owner
    cost-center         = var.cost_center
    managed-by          = "terraform"
    data-classification = var.data_classification
  }
}
