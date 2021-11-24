output "id" {
  value = data.aws_ami.this.id
}

output "block_device_mappings" {
  value = data.aws_ami.this.block_device_mappings
}
