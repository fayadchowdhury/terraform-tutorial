# Create a file and call it pet.txt
# and paste the given content
resource "local_file" "pet" {
    filename = "pet.txt"
    content = "We love pets!"
    file_permission = 0700 # Update this line; this will delete the resource and then recreated (since the resource is immutable)
}

resource "random_pet" "my-pet" {
    prefix = "Mrs"
    separator = "."
    length = 1
}