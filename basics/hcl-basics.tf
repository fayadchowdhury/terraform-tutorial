# Create a file and call it pet.txt
# and paste the given content
resource "local_file" "pet" {
    filename = "pet.txt"
    content = "We love pets!"
}