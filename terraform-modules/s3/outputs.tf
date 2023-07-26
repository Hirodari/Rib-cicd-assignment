# export the s3 bucket name
output "env_file_bucket_name" {
  value = aws_s3_bucket.env_file_bucket
}

# export the environment file name
output "env_filename" {
  value = var.env_filename
}