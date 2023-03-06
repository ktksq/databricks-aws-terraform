resource "aws_s3_bucket" "external" {
  bucket = "${local.prefix}-${var.external_storage_label}"
  acl    = "private"
  versioning {
    enabled = false
  }
  force_destroy = true
  tags = merge(local.tags, {
    Name = "${local.prefix}-${var.external_storage_label}"
  })
}

resource "aws_s3_bucket_public_access_block" "external" {
  bucket             = aws_s3_bucket.external.id
  ignore_public_acls = true
  depends_on         = [aws_s3_bucket.external]
}

resource "aws_iam_policy" "external_data_access" {
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_s3_bucket.external.id}-access"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          aws_s3_bucket.external.arn,
          "${aws_s3_bucket.external.arn}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
  tags = merge(local.tags, {
    Name = "${local.prefix}-unity-catalog ${var.external_storage_label} access IAM policy"
  })
}

resource "aws_iam_role" "external_data_access" {
  name                = "${local.prefix}-external-access"
  assume_role_policy  = data.aws_iam_policy_document.passrole_for_uc.json
  managed_policy_arns = [aws_iam_policy.external_data_access.arn]
  tags = merge(local.tags, {
    Name = "${local.prefix}-unity-catalog ${var.external_storage_label} access IAM role"
  })
}

resource "databricks_storage_credential" "external" {
  provider = databricks.workspace
  name = aws_iam_role.external_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.external_data_access.arn
  }
  depends_on = [time_sleep.wait]
}

resource "databricks_external_location" "this" {
  provider = databricks.workspace
  name            = "${var.external_storage_label}"
  url             = "s3://${local.prefix}-${var.external_storage_label}/${var.external_storage_location_label}"
  credential_name = databricks_storage_credential.external.id
}

// https://kb.databricks.com/en_US/terraform/failed-credential-validation-checks-error-with-terraform
resource "time_sleep" "wait" {
  depends_on = [aws_iam_role.external_data_access]
  create_duration = "10s"
}