resource "local_file" "file" {
    filename = var.filename
    content = var.content
}