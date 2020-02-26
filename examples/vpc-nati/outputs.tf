output id {
  value = module.vpc.id
}

output default_security_group_id {
  value = module.vpc.default_security_group_id
}

output private_subnet_ids {
  value = module.vpc.private_subnet_ids
}

output public_subnet_ids {
  value = module.vpc.public_subnet_ids
}

# output cloud_map_namespace_id {
#   value = module.cloud_map.namespace_id
# }
#
# output cloud_map_namespace_name {
#   value = module.cloud_map.namespace_name
# }
