# Migrate

1. With the older Terraform version (version 0.8.x), run terraform remote pull

2. ```shell
   $ tf -v
   Terraform v0.8.8
   
   Your version of Terraform is out of date! The latest version
   is 0.12.12. You can update by downloading from www.terraform.io
   
   $ tf remote pull
   ```

2. Backup your `.terraform/terraform.tfstate` file. 

   ```shell
   $ cp -pi .terraform/terraform.tfstate /path/to/terraform.tfstate
   ```

3. [Configure your backend](https://www.terraform.io/docs/backends/config.html) in your Terraform configuration. 

4. ```HCL
   terraform {
     required_version = "0.9.0"
     backend "s3" {
       bucket = "terraform-aws-modules-tfstate"
       region  = "ap-northeast-1"
       key     = "v000900/development/terraform.tfstate"
     }
   }
   ```

4. [Run the init command](https://www.terraform.io/docs/backends/init.html).

5. ```shell
   $ tf -v
   Terraform v0.9.0
   
   Your version of Terraform is out of date! The latest version
   is 0.12.12. You can update by downloading from www.terraform.io
   
   $ tf init
   ```

5. Verify your state looks good by running `terraform plan` and seeing if it detects your infrastructure. Advanced users may run `terraform state pull` which will output the raw contents of your state file to your console