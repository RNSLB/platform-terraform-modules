# Platform Terraform Modules

Reusable infrastructure modules with cost-optimized defaults.

## Modules

1. **VPC** - Network foundation (~$64/month with NAT)
2. **ECS Service** - Container runner (~$30-50/month)
3. **RDS** - PostgreSQL database (~$15/month)

## Quick Start
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  name               = "production"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "ecs_service" {
  source = "./modules/ecs-service"
  
  service_name       = "my-app"
  cluster_name       = "prod-cluster"
  container_image    = "nginx:latest"
  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source = "./modules/rds"
  
  db_name            = "appdb"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
}
```

## Complete Example

See [examples/complete-stack/main.tf](examples/complete-stack/main.tf)

## Cost Estimates

**Production (~$150/month):**
- VPC with NAT: $64/month
- ECS (2-10 tasks): $30-100/month
- RDS db.t3.micro: $15/month

**Development (~$30/month):**
- VPC without NAT: $0/month
- ECS (1-2 tasks): $15-20/month
- RDS db.t3.micro: $15/month

## Why Modules?

**Without:**
- Each team writes infrastructure from scratch
- Inconsistency
- Security gaps
- Hard to maintain

**With:**
- Write once, use everywhere
- Standards enforced
- Cost-optimized defaults
- Self-service

## Platform Engineering Principles

1. **Paved Roads** - Easy path to production
2. **Self-Service** - No tickets required
3. **Standards** - Best practices baked in
4. **Cost Awareness** - Transparent pricing

## Interview Talking Points

"I built Terraform modules that create production-ready infrastructure in minutes. Each module has cost-optimized defaults. For example, NAT Gateways cost $32/month each, so teams can disable them in dev. This is self-service platform engineering - teams use modules like Lego blocks instead of filing tickets."

## License

MIT
