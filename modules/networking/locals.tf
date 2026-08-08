# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Local maps used to create stable per-Availability-Zone networking resources.

locals {
  # Build a map of availability zones indexed by AZ name with their list position
  az_map = {
    for index, az in var.availability_zones : az => {
      index = index
    }
  }

  # Determine NAT Gateway placement: disabled (empty), single AZ, or multi-AZ
  nat_gateway_map = var.enable_nat_gateway ? (
    var.single_nat_gateway ? {
      (var.availability_zones[0]) = local.az_map[var.availability_zones[0]]
    } : local.az_map
  ) : {}
}
