resource "aws_lambda_function" "my_lambda_function" {
  function_name = "lambda_function"
  role          = aws_iam_role.my_lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 30
  memory_size   = 128
  layers        = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python38:18"] #https://aws-sdk-pandas.readthedocs.io/en/stable/layers.html
  environment {
    variables = {
      "glue_catalog_table_name" = "cleansed_statistics_reference_data",
      "write_data_operation"    = "append",
      "glue_catalog_db_name"    = "cleansed_youtube",
      "s3_cleansed_layer"       = "s3://${aws_s3_bucket.cleansed_bucket.id}/youtube/cleansed_statistics_reference_data/"
    }
  }
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  depends_on = [ aws_glue_catalog_database.cleansed_youtube ]
}


# resource "aws_lambda_function_event_invoke_config" "my_lambda_trigger" {
#     function_name = aws_lambda_function.my_lambda_function.function_name
#     maximum_event_age_in_seconds = 300
#     maximum_retry_attempts = 2
# }


resource "aws_s3_bucket_notification" "lambda_trigger" {
    bucket = aws_s3_bucket.data_bucket.id
    
    lambda_function {
        lambda_function_arn = aws_lambda_function.my_lambda_function.arn
        events              = ["s3:ObjectCreated:*"]
        filter_prefix = "youtube/raw_statistics_reference_data/"
        filter_suffix       = ".json"
    }
    depends_on = [ aws_lambda_permission.allow_bucket ]
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}