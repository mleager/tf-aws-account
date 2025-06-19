# Global S3 Terraform State Management

Creates an S3 Bucket with the purpose of housing the state and lock files of multiple Terraform configs.

**Directory Structure**

Global S3 Bucket: my-terraform-state-bucket
├── tf-config-1/
│   └── terraform.tfstate
├── tf-config-2/
│   └── terraform.tfstate
└── tf-config-3/
    └── terraform.tfstate


## Creating the Global Bucket

When creating the Global Bucket, you have to provision the bucket before you can use it as a Remote Backend.

1. Comment out backend "s3" {} block

2. Run: terraform init, plan, apply

3. Uncomment the backend "s3" {} block

4. Run terraform init again

5. When prompted for input, type "yes" to copy the local state to the S3 Bucket


## Using it in Other Terraform Configs

Use the same S3 Bucket for the Backend in other Terraform projects.

Modify the "key" attribute with the respective Terraform project

Example: 
```terraform
backend "s3" {
  bucket       = "your-global-bucket"
  key          = "current-terraform-project/terraform.tfstate"
  region       = "your-region"
  encrypt      = true
  use_lockfile = true
}
```

