module "tf-vpc" {
	source = "../modules"
	environment = "DEV"
}

output "vpc-cidr_block" {
	value = module.tf-vpc.vpc_cidr

}