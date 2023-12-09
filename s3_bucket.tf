resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "s3-ittalent-terraform-gabriel-lins"
}

resource "aws_s3_bucket_website_configuration" "name" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_acl" "static_site_bucket" {
  bucket     = aws_s3_bucket.static_site_bucket.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.static_site_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_access_from_everywhere" {
  bucket     = aws_s3_bucket.static_site_bucket.id
  policy     = data.aws_iam_policy_document.allow_public_access_from_everywhere.json
  depends_on = [aws_s3_bucket_public_access_block.example]
}

data "aws_iam_policy_document" "allow_public_access_from_everywhere" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.static_site_bucket.arn,
      "${aws_s3_bucket.static_site_bucket.arn}/*",
    ]
  }
}
