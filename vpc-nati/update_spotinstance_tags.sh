#!/usr/bin/env bash

#$1 = ${var.region}
#$2 = ${aws_spot_instance_request.platform.id}
#$3 = ${aws_spot_instance_request.platform.spot_instance_id}
#
# aws --region $1 ec2 describe-spot-instance-requests --spot-instance-request-ids $2 --query 'SpotInstanceRequests[0].Tags' > tags.json
# aws ec2 create-tags --resources $3 --tags file://tags.json
# rm -f tags.json
#
TAGS=$(aws ec2 describe-spot-instance-requests \
--region $1 \
--spot-instance-request-ids $2 \
--query 'SpotInstanceRequests[0].Tags')

aws ec2 create-tags --region $1 --resources $3 --tags "$TAGS"
