resource "aws_iam_group" "namespace_read_group" {
  name = "${local.prefix}-${local.namespace}-read"
}

resource "aws_iam_group_policy_attachment" "attach_ops_assumable_policy" {
  group = "${aws_iam_group.namespace_read_group.name}"
  policy_arn = "${aws_iam_policy.namespace_read_policy.arn}"
}