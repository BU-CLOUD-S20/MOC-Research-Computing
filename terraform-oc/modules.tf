module "frontend"{
    source= "./modules/frontend"
}

module "middleware" {
    source=  "./modules/middleware"
}