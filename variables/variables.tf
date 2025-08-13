variable "filename" {
    default = "file.txt"
    type = string
    description = "The name of the file"
}

variable "content" {
    type = string
    description = "The content to be placed in the file"
}