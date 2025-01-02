variable "project_name" {
    default = "expense"
}

variable "environment" {

    default = "dev"
}

variable "common_tags" {
    type = map
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
        Component = "backend"
    }
}

variable zone_name {
    default = "swamy.fun"
}

variable zone_id {
    default = "Z091269018P6LHQ5RFF38"
}