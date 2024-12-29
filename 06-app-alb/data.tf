data "aws_ssm_parameter" "app-alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/app-alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}


data "aws_ami" ami_info {

    most_recent = true
    owners = ["679593333241"]
    
    filter {
       name   = "name"
       values = ["OpenVPN Access Server Community Image-*"]
    }
    
    filter {
      name   = "root-device-type"
      values = ["ebs"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    filter {
      name   = "product-code"
      values = ["f2ew2wrz425a1jagnifd02u5t"]
    }

}
