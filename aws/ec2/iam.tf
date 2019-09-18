resource "aws_iam_role" "ssm" {
  name = "AmazonEC2RoleforSSM"

  assume_role_policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action":"sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = "${aws_iam_role.ssm.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "AmazonEC2RoleforSSM"
  role = "${aws_iam_role.ssm.id}"
}
