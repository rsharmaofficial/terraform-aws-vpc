# provider "aws" {
#   region = "ap-south-1"  # Replace with your desired AWS region
# }

# module "vpc" {
#   source = "./module/vpc"

#   vpc_config = {
#     cidr_block = "10.0.0.0/16"
#     name       = "my-vpc"
#   }

#   subnet_config = {
#     # Public Subnet 1
#     public_subnet1 = {
#       cidr_block        = "10.0.0.0/24"
#       availability_zone = "ap-south-1a"  # Corrected availability zone format
#       public=true
#     }

#     private_subnet1 = {
#       cidr_block        = "10.0.1.0/24"
#       availability_zone = "ap-south-1b"  # Corrected availability zone format
#   }
#      }
# }

provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region
}

module "vpc" {
  source = "./module/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-vpc"
  }

  subnet_config = {
    # Public Subnet 1
    public_subnet1 = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-south-1a"
      public            = true
    }

    # Private Subnet 1
    private_subnet1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-south-1b"
    }
  }
}
