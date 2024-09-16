resource "aws_ecr_repository" "ECR" {
  name                 = "fcjws2"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}