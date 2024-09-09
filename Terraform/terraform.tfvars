vpc_name = "VPC for Kubernetes"

vpc_cidr = "10.0.0.0/16"

vpc_azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

vpc_public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

vpc_private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

# EC2 variables

ec2_name = "Jenkins Server EC2"

ec2_instance_type = "t2.medium"

ec2_key_name = "EC2"

ec2_ami = "ami-0a0e5d9c7acc336f1" // Ubuntu 22.04