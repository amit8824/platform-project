resource "aws_ecr_repository" "platform" {

  name = "platform-api"

  force_delete = true

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
