output id {
  value = module.vpc.id
}

output default_security_group_id {
  value = module.vpc.default_security_group_id
}

output public_subnet_ids {
  value = module.vpc.public_subnet_ids
}

output private_subnet_ids {
  value = module.vpc.private_subnet_ids
}
