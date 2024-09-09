resource "aws_eks_node_group" "my_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "ClusterNode"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  capacity_type  = "ON_DEMAND"
  instance_types = [var.ec2_instance_type]

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEC2ContainerRegistryReadOnly,
    module.eks.cluster_id
  ]
}