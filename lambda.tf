resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my-lambda-function"
  role          = aws_iam_role.my_lambda_role.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.8"
  timeout       = 60
  memory_size   = 128

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
}


