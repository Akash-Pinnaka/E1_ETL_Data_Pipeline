# resource "aws_glue_job" "replicate_lambda_job" {
#     name        = "replicate_lambda_job"
#     description = "Glue job to replicate Lambda function and convert JSON to Parquet"

#     role_arn = aws_iam_role.glue_crawler_role.arn

#     command {
#         name             = "glueetl"
#         script_location = "s3://your-bucket-name/your-glue-script.py"
#     }

#     default_arguments = {
#         "--enable-metrics"                  = "true"
#         "--enable-continuous-cloudwatch-log" = "true"
#     }

#     execution_property {
#         max_concurrent_runs = 1
#     }

#     worker_type       = "Standard"
#     number_of_workers = 2

#     glue_version = "2.0"
# }
