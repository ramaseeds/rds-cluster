resource "aws_db_subnet_group" "primary_db_subnet_group" {
  provider   = aws.primary
  name       = "primary-db-subnet-group"
  subnet_ids = [
    for s in data.aws_subnet.primary_filtered_subnets :
    s.id if s.availability_zone == "us-east-2b" || s.availability_zone == "us-east-2c"
  ]

  tags = {
    Name = "Primary DB Subnetes Group"
  }
}

resource "aws_db_subnet_group" "replica_db_subnet_group" {
  provider   = aws.replica
  name       = "replica-db-subnet-group"
  subnet_ids = [
    for s in data.aws_subnet.replica_filtered_subnets :
    s.id if s.availability_zone == "us-west-2b" || s.availability_zone == "us-west-2c"
  ]

   tags = {
    Name = "Replica DB Subnetes Group"
  }
}

resource "aws_db_instance" "primary" {
  identifier              = "primary-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username               = "admin"
  password               = "SuperSecret123!"
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name    =  aws_db_subnet_group.primary_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.primary_rds_sg.id]
  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  apply_immediately = true

  # Enable Enhanced Monitoring
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.primary_rds_monitoring.arn
}


resource "aws_db_instance" "read_replica" {
  provider               = aws.replica
  identifier             = "replica-db"
  instance_class         = "db.t3.micro"
  replicate_source_db    = aws_db_instance.primary.arn
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.replica_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.replica_rds_sg.id]

  # Enable Enhanced Monitoring on Read Replica
  monitoring_interval    = 60
  monitoring_role_arn    = aws_iam_role.replica_rds_monitoring.arn
}
