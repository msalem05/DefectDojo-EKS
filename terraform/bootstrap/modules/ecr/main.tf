resource "aws_ecr_repository" "repo" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  repository = aws_ecr_repository.repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Delete untagged images older than 14 days"

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }

        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only the latest 3 tagged images"

        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "imageCountMoreThan"
          countNumber    = 3
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}