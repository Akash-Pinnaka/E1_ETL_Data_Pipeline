provider "aws" {
    region = "us-east-1" 
}

resource "aws_s3_bucket" "my_bucket" {
    bucket = "etl-datapipeline-bucket-akashp7"
    force_destroy = true

    tags = {
        Name = "etl-datapipeline-bucket-akashp7"
        }
}

resource "aws_s3_object" "fill_bucket" {
    for_each = fileset("${path.module}/data", "**/*.csv")

    bucket = aws_s3_bucket.my_bucket.id
    key = "fill_bucket"
    source = "fill_bucket"
  
}