resource "aws_glue_catalog_database" "youtube" {
  name = "youtube"
}

resource "aws_glue_crawler" "ytdata_crawler" {
  name          = "ytdata-crawler"
  description   = "crawls the youtube data bucket"
  database_name = aws_glue_catalog_database.youtube.name
  role          = aws_iam_role.glue_crawler_role.arn
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.data_bucket.id}"
  }
  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${self.name}"
  }
}

