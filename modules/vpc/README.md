# VPC Module

Creates production-ready VPC with high availability.

## Usage
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  name               = "production"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}
```

## Cost

- NAT Gateway: ~$32/month per AZ
- 2 AZs = ~$64/month
- Disable for dev: `enable_nat_gateway = false`

## Features

- Public & private subnets across 2+ AZs
- NAT Gateways (optional)
- VPC Flow Logs (optional)
- Automatic CIDR calculation
