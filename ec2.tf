resource "aws_instance" "test" {
  count                  = length(var.subnet-cidrs)
  ami                    = "ami-065ab11fbd3d0323d"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "TF_EC2 in AZ: ${var.azs[count.index]}"
  }


  user_data = base64encode(templatefile("init.sh.tpl", { example = aws_vpc.main.id, subnet = aws_subnet.public_subnets[count.index].id }))
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
  }
}
