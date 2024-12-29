module "db" {
    source = "../../terraform-swamy-aws-sg"
    sg_name = "db"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for DB MySQL Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}

module "backend" {
    source = "../../terraform-swamy-aws-sg"
    sg_name = "backend"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for backend Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}

module "frontend" {
    source = "../../terraform-swamy-aws-sg"
    sg_name = "frontend"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for frontend Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}

module "bastion" {
    source = "../../terraform-swamy-aws-sg"
    sg_name = "bastion"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for bastion Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}


module "app-alb" {
    source = "../../terraform-swamy-aws-sg"
    sg_name = "app-alb"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for app-alb Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}

module "vpn" {
    source = "../../terraform-swamy-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for vpn Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    inbound_rules = var.vpn_sg_rules
    sg_name = "vpn"
}

# DB is accpeting traffic from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id  # source is where you are getting traffic from 
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic from 
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from 
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_app-alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb.sg_id  # source is where you are getting traffic from 
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic from 
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from 
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from 
  security_group_id = module.backend.sg_id
}



resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic from 
  security_group_id = module.frontend.sg_id
}


resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "app-alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from 
  security_group_id = module.app-alb.sg_id
}
