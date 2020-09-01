data "aws_iam_policy_document" "namespace_read_role_assumable_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "${aws_iam_role.read_role.arn}",
    ]

    condition {
      test     = "StringEqualsIgnoreCase"
      values   = ["&{aws:username}"]
      variable = "sts:RolesSessionName"
    }
  }

  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "NotIpAddressIfExists"
      values   = "${var.cidr_restrictions}"
      variable = "aws:SourceIp"
    }

    condition {
      test     = "BoolIfExists"
      values   = ["false"]
      variable = "aws:ViaAWSService"
    }
  }
}

resource "aws_iam_policy" "read_role_assumable_policy" {
  name   = "${local.prefix}-${local.namespace}-read-assumable-role"
  path   = "${local.policy_path}"
  policy = "${data.aws_iam_policy_document.namespace_read_role_assumable_document.json}"
}