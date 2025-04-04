provider "aws" {
    region = var.aws_region
}

resource "null_resource" "clone_github_repo" {
  provisioner "local-exec" {
    command = "git clone ${var.github_repo_url}"
  }
}

data "local_file" "ssm_document_content" {
  depends_on = [null_resource.clone_github_repo]
  filename   = var.file_path
}

resource "aws_ssm_document" "create_ssm_document" {
  depends_on = [null_resource.clone_github_repo]

  name            = var.ssm_document_name
  document_format = var.ssm_document_format
  document_type   = var.ssm_document_type
  content         = data.local_file.ssm_document_content.content
  tags            = var.ssm_document_tags
}