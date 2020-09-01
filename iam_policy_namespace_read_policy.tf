data "aws_iam_policy_document" "namespace_read_policy_document" {
  statement {
    sid = "Crypto"

    actions = [
      "kms:Decrypt",
      "kms:Verify",
    ]

    resources = [
      "arn:aws:kms:*:${var.account_id}:key/${local.prefix}/${local.namespace}/*",
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
      "arn:aws:s3:*:${var.account_id}:${local.prefix}-${local.namespace}/*",
    ]
  }
}

resource "aws_iam_policy" "namespace_read_policy" {
  name   = "${local.policy_path}read-policy"
  policy = "${data.aws_iam_policy_document.namespace_read_policy_document.json}"
}
