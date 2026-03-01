# ECS Service Module

Runs Docker containers with auto-scaling and load balancing.

## Usage
```hcl
module "ecs_service" {
  source = "./modules/ecs-service"
  
  service_name    = "my-app"
  cluster_name    = "production"
  container_image = "nginx:latest"
  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}
```

## Cost

- Fargate: ~$30-50/month (2-10 tasks)
- Task: 0.25 vCPU + 0.5GB = ~$15/month per task

## Features

- Application Load Balancer
- Auto-scaling (CPU & memory based)
- Health checks
- CloudWatch logs
