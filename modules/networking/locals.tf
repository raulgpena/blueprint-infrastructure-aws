# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Local maps used to create stable per-Availability-Zone networking resources.

locals {
  az_map = {
    for index, az in var.availability_zones : az => {
      index = index
    }
  }

  nat_gateway_map = var.enable_nat_gateway ? (
    var.single_nat_gateway ? {
      (var.availability_zones[0]) = local.az_map[var.availability_zones[0]]
    } : local.az_map
  ) : {}
}
