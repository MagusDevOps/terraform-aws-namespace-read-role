output "read_assumable_policy_arn" {
  value = "${aws_iam_policy.read_role_assumable_policy.arn}"
}

output "assumable_read_role_name" {
  value = "${aws_iam_role.read_role.name}"
}

output "read_role_arn" {
  value = "${aws_iam_role.read_role.arn}"
}

