# RDS Module

Managed PostgreSQL database with encryption and backups.

## Usage
```hcl
module "rds" {
  source = "./modules/rds"
  
  db_name = "appdb"
  
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
}
```

## Cost

- db.t3.micro: ~$15/month (Single-AZ)
- Multi-AZ: Doubles cost but adds HA

## Features

- Automatic backups (7 days)
- Encryption at rest
- Password in SSM Parameter Store
- CloudWatch logs
