resource "aws_glue_catalog_database" "youtube" {
  name = "youtube"
}

resource "aws_glue_catalog_database" "cleansed_youtube" {
  name = "cleansed_youtube"
}
resource "aws_glue_crawler" "csv_crawler" {
  name          = "csv_crawler"
  description   = "crawls the csv data in bucket"
  database_name = aws_glue_catalog_database.youtube.name
  role          = aws_iam_role.glue_crawler_role.arn
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.data_bucket.id}/youtube/raw_statistics/"
  }
  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${self.name}"
  }
  depends_on = [ aws_s3_object.fill_csv_data ]
}

resource "aws_glue_crawler" "json_crawler" {
  name          = "json_crawler"
  description   = "crawls the cleansed parquet bucket"
  database_name = aws_glue_catalog_database.cleansed_youtube.name
  role          = aws_iam_role.glue_crawler_role.arn
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.cleansed_bucket.id}/youtube/cleansed_statistics_reference_data/"
  }
  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${self.name}"
  }
  depends_on = [ aws_lambda_function.my_lambda_function ]
}