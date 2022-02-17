resource "aws_s3_bucket" "b" {
  for_each = var.s3_elasticsearch_backup
  bucket = each.key
  acl = "private"

  versioning {
        enabled = true
  }
}

resource "aws_s3_bucket_policy" "p1" {
  for_each = aws_s3_bucket.b

  bucket = each.key
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "s3_elasticsearch_backup",
    Statement = [
      {
        Sid       = "s3_elasticsearch_backup_policy_main"
        Effect    = "Allow"
        Principal = "*"
        Action    =  "s3:*"
        Resource  = each.value.arn
          }
        }
      }
    ]
  )

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
