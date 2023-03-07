# output "instance_test_id" {
#   description = "ID of the t2micro_ubuntu_test"
#   value       = aws_instance.t2micro_ubuntu_test.id
# }

output "aws_ami" {
    value = data.aws_ami.ubuntu20_latest.id
}

# output "instance_test_sg_ids" {
#   value = aws_instance.t2micro_ubuntu_test.vpc_security_group_ids
# }

output "instance_test_public_ip" {
  description = "Public IP address of the t2micro_ubuntu_test"
  value = aws_instance.t2micro_ubuntu_test.public_ip
}

output "instance_test_public_dns" {
  value = aws_instance.t2micro_ubuntu_test.public_dns
}

output "instance_prod_1_public_ip" {
  description = "Public IP address of the t2micro_ubuntu_prod"
  value = aws_instance.t2micro_ubuntu_prod_1.public_ip
}

output "instance_prod_1_public_dns" {
  value = aws_instance.t2micro_ubuntu_prod_1.public_dns
}

output "instance_prod_2_public_ip" {
  description = "Public IP address of the t2micro_ubuntu_prod"
  value = aws_instance.t2micro_ubuntu_prod_2.public_ip
}

output "instance_prod_2_public_dns" {
  value = aws_instance.t2micro_ubuntu_prod_2.public_dns
}

output "elb_public_dns_name" {
  value = aws_alb.alb.dns_name
}
