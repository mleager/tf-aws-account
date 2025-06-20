# Global S3 Terraform State Management

Creates an S3 Bucket with the purpose of housing the state and lock files of multiple Terraform configs.

DynamoDB use for state-locking is deprecated.

Uses S3 `use_lockfile` attribute for state locking.

[Terraform Docs](https://developer.hashicorp.com/terraform/language/backend/s3)


**Directory Structure**
```
Global S3 Bucket: my-terraform-state-bucket
├── tf-config-1/
│   └── terraform.tfstate
├── tf-config-2/
│   └── terraform.tfstate
└── tf-config-3/
    └── terraform.tfstate
```

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


## Creating a Composite Action to Use the S3 Backend

To use the S3 Backend per repo without hard-coding each workflow, I created  
a composite action.

Does the following:

1. Calls setup-terraform action
2. Calls aws-configure action
3. Runs terraform format
4. Runs terraform init with -backend-config from inputs
5. Runs terraform validate
6. Runs terraform plan

This allows the action to be used for any terraform workflow.

Example use:

```yaml
name: Terraform Apply

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./terraform
    steps:
      - name: Terraform Plan Setup
        uses: mleager/tf-shared-actions/.github/actions/terraform-plan@main
        with:
          # optional - bucket: tf-state-8864
          key: tf-s3-global-state/terraform.tfstate
          region: ${{ vars.AWS_REGION }}
          var_file: terraform.tfvars.development

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -var-file=terraform.tfvars.development -auto-approve
```

