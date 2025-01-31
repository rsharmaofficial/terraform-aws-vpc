# variable "vpc_config" {
#   description = "to get the cidr and name of vpc from the user "
#   type = object({
#     name       = string
#     cidr_block = string
#   })





# }




# variable "subnet_config" {
#   #sub1{cidr.... az...}
#   #sub2{cidr.... az...}
#   #sub3{cidr.... az...}
#   description = "to get the cidr and az of subnets from the user"
#   type = map(object({
#     cidr_block        = string
#     availability_zone = string
#     public= optional(bool, false)
#   }))
#   validation {
#     condition     = alltrue([for config in var.subnet_config : can(cidrnetmask(config.cidr_block))])
#     error_message = "invalid cidr block "
#   }
# }


variable "vpc_config" {
  description = "VPC CIDR and name configuration"
  type = object({
    name       = string
    cidr_block = string
  })
}

variable "subnet_config" {
  description = "Subnet CIDR, availability zone, and public/private setting"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = optional(bool, false)  # Default to private if not specified
  }))

  validation {
    condition = alltrue([
      for config in var.subnet_config : 
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", config.cidr_block))
    ])
    error_message = "Invalid CIDR block format. Example: 10.0.0.0/24"
  }
}
