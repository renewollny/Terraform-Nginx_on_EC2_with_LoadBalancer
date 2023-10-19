resource "aws_subnet" "public_subnets" {
  count                   = length(var.subnet-cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet-cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "TF_Subnet_${var.azs[count.index]}"
  }
}
