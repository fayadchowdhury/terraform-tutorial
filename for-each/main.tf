resource "local_file" "files" {
    filename = each.value
    content = "${each.value} content"
    for_each = var.filenames
}

output "files" {
    value = local_file.files
    sensitive = true # Is there a way to bypass this??
}