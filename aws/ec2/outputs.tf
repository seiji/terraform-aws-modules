output "public_dns" {
  value = aws_instance.this.*.public_dns
}

output "public_ip" {
  value = aws_instance.this.*.public_ip
}

output "private_ip" {
  value = aws_instance.this.*.private_ip
}
