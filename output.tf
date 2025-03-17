output "primary_subnets" {
  value = [
    for s in values(data.aws_subnet.primary_filtered_subnets) :
    s.id if s.availability_zone == "us-east-2b" || s.availability_zone == "us-east-2c"
  ]
}

output "replica_subnets" {
  value = [
    for s in values(data.aws_subnet.replica_filtered_subnets) :
    s.id if s.availability_zone == "us-west-2b" || s.availability_zone == "us-west-2c"
  ]
}

output "primt_db_endpooint" {
    value = aws_db_instance.primary.endpoint
}

output "replica_endpoint" {
    value = aws_db_instance.read_replica.endpoint
}