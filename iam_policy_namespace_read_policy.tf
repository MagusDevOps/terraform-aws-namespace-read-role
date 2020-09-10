data "aws_iam_policy_document" "namespace_read_policy_document" {
  statement {
    sid = "Crypto"

    actions = [
      "kms:Decrypt",
      "kms:Verify",
    ]

    condition {
      test     = "StringEqualsIgnoreCase"
      values   = ["${local.namespace}"]
      variable = "iam:ResourceTag/${var.namespace_tag_key}"
    }

    condition {
      test     = "StringEqualsIgnoreCase"
      values   = ["${var.prefix}"]
      variable = "iam:ResourceTag/${var.prefix_tag_key}"
    }

    resources = [
      "arn:aws:kms:*:${var.account_id}:key/*",
    ]
  }

  statement {
    sid = "queuing"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      "arn:aws:sqs:*:${var.account_id}:${local.queue_prefix}*",
    ]
  }

  statement {
    sid = "dynamo"

    actions = [
      "dynamodb:Condition*",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:Scan",
    ]

    resources = [
      "arn:aws:dynamodb:*:${var.account_id}:table/${local.prefix}_${local.namespace}*",
    ]
  }

  statement {
    sid = "s3"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.prefix}-${local.namespace}*",
    ]
  }

  statement {
    sid = "keyspace"

    actions = [
      "cassandra:Select",
    ]

    resources = [
      "arn:aws:cassandra:*:${var.account_id}:/keyspace/${local.prefix}_${local.namespace}/",
      "arn:aws:cassandra:*:${var.account_id}:/keyspace/${local.prefix}_${local.namespace}/table/*",
    ]
  }
}

resource "aws_iam_policy" "namespace_read_policy" {
  name   = "${local.prefix}-${local.namespace}-read-policy"
  path   = "${local.policy_path}"
  policy = "${data.aws_iam_policy_document.namespace_read_policy_document.json}"
}
