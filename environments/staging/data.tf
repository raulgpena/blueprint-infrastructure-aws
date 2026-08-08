# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Staging environment data sources.

# Fetch the list of active AWS Availability Zones in the region to distribute subnets.
data "aws_availability_zones" "available" {
  state = "available"
}
