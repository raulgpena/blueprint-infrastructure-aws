# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Prod environment data sources.

data "aws_availability_zones" "available" {
  state = "available"
}
