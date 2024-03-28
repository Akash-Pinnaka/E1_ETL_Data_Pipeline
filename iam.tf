#IAM role and policy for glue crawler
resource "aws_iam_role" "glue_crawler_role" {
    name = "glue-crawler-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "glue.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "glue_crawler_policy_attachment" {
    role      = aws_iam_role.glue_crawler_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_crawler_s3_policy" {
    name        = "glue-crawler-s3-policy"
    role        = aws_iam_role.glue_crawler_role.id
    policy      = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:GetObject",
                    "s3:ListBucket",
                    "s3:PutObject"
                ],
                "Resource": [
                    "arn:aws:s3:::${aws_s3_bucket.data_bucket.id}*"
                ]
            }
        ]
    })
}

#IAM role and policies for lambda func
resource "aws_iam_role" "my_lambda_role" {
  name = "my-lambda-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "glue_crawler_lambda_policy_attachment" {
  role       = aws_iam_role.my_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "s3_access_attachment" {
  role = aws_iam_role.my_lambda_role.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          #   "s3:GetObject",
          #   "s3:PutObject",
          #   "s3:DeleteObject"
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.data_bucket.id}*",
          "arn:aws:s3:::${aws_s3_bucket.cleansed_bucket.id}*"
        ]
      }
    ]
  })
}

