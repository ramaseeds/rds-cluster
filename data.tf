data "aws_vpc" "primary_vpc_id" {
  provider = aws.primary
  id       = "vpc-328aef59"
}

data "aws_vpc" "replica_vpc_id" {
  provider = aws.replica
  id       = "vpc-d3de8eab"
}

data "aws_subnets" "primary_subnets" {
  provider = aws.primary
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.primary_vpc_id.id]
  }
}

data "aws_subnet" "primary_filtered_subnets" {
    provider = aws.primary
    for_each = toset(data.aws_subnets.primary_subnets.ids)
    id = each.value
}

data "aws_subnets" "replica_subnets" {
  provider = aws.replica
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.replica_vpc_id.id]
  }

}

data "aws_subnet" "replica_filtered_subnets" {
    provider = aws.replica
    for_each = toset(data.aws_subnets.replica_subnets.ids)
    id = each.value
}