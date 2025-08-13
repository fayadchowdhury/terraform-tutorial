resource "local_file" "file" {
    filename = var.filename
    content = "This was written by ${random_pet.my-pet.id}"
}

resource "random_pet" "my-pet" {
    prefix = "Mr."
    separator = "."
    length = 3
}