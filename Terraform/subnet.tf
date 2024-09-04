// Public Subnet
resource "aws_subnet" "public_subnets" {
  for_each                = toset(var.vpc_public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.vpc_azs[index(var.vpc_public_subnets, each.value)]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${index(var.vpc_public_subnets, each.value) + 1}"
  }
}

// Private Subnet
resource "aws_subnet" "private_subnets" {
  for_each          = toset(var.vpc_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.vpc_azs[index(var.vpc_private_subnets, each.value)]

  tags = {
    Name = "Private Subnet ${index(var.vpc_private_subnets, each.value) + 1}"
  }
}