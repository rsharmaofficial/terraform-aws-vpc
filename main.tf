# # Define the main VPC resource
# resource "aws_vpc" "main" {
#     # Set the CIDR block for the VPC from the variable
#     cidr_block = var.vpc_config.cidr_block
    
#     # Add tags to the VPC
#     tags = {
#         Name = var.vpc_config.name  # Set the name tag from the variable
#     }
# }

# # Define the main subnet resource
# resource "aws_subnet" "main" {
#     # Iterate over each subnet configuration
#     for_each = var.subnet_config

#     # Set the VPC ID for the subnet
#     vpc_id = aws_vpc.main.id
    
#     # Set the CIDR block for the subnet from the configuration
#     cidr_block = each.value.cidr_block
    
#     # Set the availability zone for the subnet from the configuration
#     availability_zone = each.value.availability_zone

#     # Add tags to the subnet
#     tags = {
#         Name = "subnet-${each.key}"  # Set the name tag with the subnet key
#     }
# }

# # Define local values
# locals {
#     # Create a map of public subnets from the subnet configuration
#     public_subnet = {
#         for key, config in var.subnet_config: key => config if config.public
#     }
# }

# # Define the internet gateway resource if there is at least one public subnet
# resource "aws_internet_gateway" "main" {
#     # Set the VPC ID for the internet gateway
#     vpc_id = aws_vpc.main.id
    
#     # Ensure only one internet gateway is created
#     count = length(local.public_subnet) >= 0 ? 1 : 0
# }


# #Routing Table
# resource "aws_route_table" "main" {
#     count = length(local.public_subnet) >= 0 ? 1 : 0
#     vpc_id = aws_vpc.main.id
     
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.main[0].id
#     }

# }


# Define the main VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_config.cidr_block

    tags = {
        Name = var.vpc_config.name
    }
}

# Create subnets dynamically
resource "aws_subnet" "main" {
    for_each = var.subnet_config

    vpc_id            = aws_vpc.main.id
    cidr_block        = each.value.cidr_block
    availability_zone = each.value.availability_zone

    tags = {
        Name = "subnet-${each.key}"
    }
}

# Local values to filter public subnets
locals {
    public_subnet = {
        for key, config in var.subnet_config : key => config if config.public
    }
    private_subnet = {
    for key, config in var.subnet_config : key => config if !config.public
    }
}


# Internet Gateway (Only if there's a public subnet)
resource "aws_internet_gateway" "main" {
    count  = length(local.public_subnet) > 0 ? 1 : 0
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main-igw"
    }
}

# Public Route Table (Only if there's a public subnet)
resource "aws_route_table" "main" {
    count  = length(local.public_subnet) > 0 ? 1 : 0
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main[0].id
    }

    tags = {
        Name = "public-route-table"
    }
}

# Associate Public Subnets with Route Table (Only if they're public)
 resource "aws_route_table_association" "main" {
    for_each       = local.public_subnet
    subnet_id      = aws_subnet.main[each.key].id
    route_table_id = aws_route_table.main[0].id
   
 }