provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "app_bucket" {
  #checkov:skip=CKV_AWS_144: gitlab is secondary source of data so cross region replication is not necessary
  bucket = "${var.airflow_s3_bucketName}"

  versioning {
    enabled = var.airflow_s3_versioning #todo bool
  }
}

resource "aws_s3_bucket_acl" "the_acl" {
  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"
}





resource "aws_s3_bucket_object" "_s3_uploads" {
  for_each = fileset("${path.module}/s3_upload/", "**/*")
  bucket = aws_s3_bucket.app_bucket.id
  acl         = "private"
  key = each.value
  source = "${path.module}/s3_upload/${each.value}"
  etag = filemd5("${path.module}/s3_upload/${each.value}")
}


resource "aws_s3_bucket_object" "_dags_folder" {
    bucket      = aws_s3_bucket.app_bucket.id
    acl         = "private"
    key         = "${var.airflow_dag_path}/"
}
variable "airflow_dag_path" {
  description = "Folder path for S3 DAG storage"
  type        = string
  default     = "dags"
}


variable "airflow_s3_bucketName" {
  type        = string
  description = "The name of the S3 bucket"
  default = "dnjsdbnskjdncsjd"
}


variable "airflow_s3_versioning" {
  type        = bool
  description = "Toggle for bucket ver$sioning. defaulting to fal$e"
  default     = false
}