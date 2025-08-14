resource "local_file" "output" {
    filename = "output.txt"
    content = data.local_file.reference.content
}

data "local_file" "reference" {
    filename = "reference.txt"
}