provider "aws" {
    region = "us-east-1" 
}

resource "aws_s3_bucket" "data_bucket" {
    bucket = "etl-datapipeline-raw-data-bucket-akashp7"
    force_destroy = true

    tags = {
        Name = "etl-datapipeline-raw-data-bucket-akashp7"
        }
    
}

resource "aws_s3_object" "fill_JSON_data" {
    for_each = fileset("${path.module}/data", "*.json")

    bucket = aws_s3_bucket.data_bucket.id
    key = "youtube/raw_statistics_reference_data/${each.value}"
    source = "${path.module}/Data/${each.value}"

    depends_on = [ aws_lambda_function.my_lambda_function, aws_s3_bucket_notification.lambda_trigger]
}

resource "aws_s3_object" "fill_csv_data" {
    for_each = fileset("${path.module}/data", "*.csv")

    bucket = aws_s3_bucket.data_bucket.id
    key = "youtube/raw_statistics/region=${lower(substr(each.value, 0, 2))}/${each.value}"
    source = "${path.module}/Data/${each.value}"
}


resource "aws_s3_bucket" "cleansed_bucket" {
    bucket = "etl-datapipeline-cleansed-data-bucket-akashp7"
    force_destroy = true

    tags = {
        Name = "etl-datapipeline-cleansed-data-bucket-akashp7"
        }
}

resource "aws_s3_bucket" "assets_bucket" {
    bucket = "etl-datapipeline-assets-data-bucket-akashp7"
    force_destroy = true

    tags = {
        Name = "etl-datapipeline-assets-data-bucket-akashp7"
    }
}

resource "aws_s3_bucket_versioning" "assets_bucket" {
    bucket = aws_s3_bucket.assets_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}