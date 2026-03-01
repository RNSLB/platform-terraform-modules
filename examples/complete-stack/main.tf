# Complete Stack Example - Using All 3 Modules Together

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Step 1: Create VPC
module "vpc" {
  source = "../../modules/vpc"

  name               = "production"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  # Enable NAT for production (costs $64/month for 2 AZs)
  enable_nat_gateway = true
  
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Step 2: Create ECS Service
module "ecs_service" {
  source = "../../modules/ecs-service"

  service_name    = "my-app"
  cluster_name    = "production-cluster"
  container_image = "nginx:latest"
  container_port  = 80

  # Cost optimization: Start small, scale as needed
  desired_count = 2
  min_capacity  = 2
  max_capacity  = 10

  task_cpu    = "256"  # 0.25 vCPU
  task_memory = "512"  # 0.5 GB

  # Use VPC outputs
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Step 3: Create RDS Database
module "rds" {
  source = "../../modules/rds"

  db_name          = "appdb"
  master_username  = "dbadmin"
  postgres_version = "15.4"

  # Cost optimization: Use smallest production instance
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  
  # Single-AZ for cost savings (Multi-AZ doubles cost)
  multi_az = false

  # Use VPC outputs
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Outputs
output "load_balancer_url" {
  description = "URL to access the application"
  value       = module.ecs_service.load_balancer_url
}

output "database_endpoint" {
  description = "Database connection endpoint"
  value       = module.rds.db_endpoint
}

output "database_password_location" {
  description = "Where to find the database password"
  value       = "AWS Systems Manager Parameter Store: ${module.rds.db_password_ssm_parameter}"
}
