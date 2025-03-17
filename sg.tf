resource "aws_security_group" "primary_rds_sg" {
  provider   = aws.primary  
  vpc_id = data.aws_vpc.primary_vpc_id.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]  # Allow traffic from replica region
  }
}

resource "aws_security_group" "replica_rds_sg" {
  provider = aws.replica
  vpc_id   = data.aws_vpc.replica_vpc_id.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]  # Allow traffic from primary region
  }
}