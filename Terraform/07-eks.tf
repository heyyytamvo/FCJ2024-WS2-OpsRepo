resource "aws_security_group" "Cluster_SG" {
  name        = "Cluster_SG"
  description = "Allow HTTP, HTTPS From Jump Host"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = []
      description      = "Allow inbound traffic on port 80"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.EC2_SG.id]
      self             = false
    },

    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"],
      description      = "Allow inbound ICMP Traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.EC2_SG.id]
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS Control Plane SG"
  }
}
module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  vpc_id                         = aws_vpc.main.id
  # subnet_ids                     = [for subnet in aws_subnet.private_subnets : subnet.id]
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]
  cluster_endpoint_public_access = true
  iam_role_arn                   = aws_iam_role.ekse_role.arn
  enable_cluster_creator_admin_permissions = true
  cluster_security_group_id = aws_security_group.Cluster_SG.id
  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  control_plane_subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Environment = "Development"
  }


  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}