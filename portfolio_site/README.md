# Portfolio Blog Application

This repository provides a **mock portfolio site** implemented with **Ruby on Rails**.  It includes a simple blog platform where posts are stored as records in a database.  Only one user (the author) can log in to manage posts, while any visitor can browse the blog.  The project comes with an accompanying Terraform configuration to deploy the application on an AWS EC2 instance.

## Features

* **Latest Rails:** Uses the latest stable version of Rails (7.x) with Ruby 3.
* **Blog posts:** Authenticated users can create, edit, and delete blog posts.  Each post has a title, body, publication date and belongs to a user.
* **User authentication:** A single author can sign up and log in/out.  Passwords are stored securely using `bcrypt`.
* **Tidy views:** Basic ERB templates for listing posts, showing individual posts and forms for new/edit operations.
* **Terraform deployment:** A sample Terraform module spins up an EC2 instance, installs Ruby/Rails, clones your repository and runs the Rails application using Puma.

## Prerequisites

To run this project in your own environment you will need:

* **Ruby 3.2 or newer** and **Rails 7.1** installed.  If you don’t have Ruby/Rails installed, see the `terraform/deploy/user_data.sh` script for an example of how to install them on a fresh Ubuntu instance.
* **PostgreSQL** server.  The default configuration assumes a local PostgreSQL instance with user `postgres` and no password; update `config/database.yml` to match your environment.
* **Bundler** – to install gems.

To deploy on AWS you will need:

* An AWS account with appropriate permissions for EC2, VPC, and key‑pairs.
* A VPC and subnet configured in your AWS account.  You must supply the IDs when applying the Terraform plan.
* A public SSH key file on your local machine; Terraform uses it to create an EC2 key pair.

## Getting started locally

1. **Install dependencies**

   ```sh
   bundle install
   ```

2. **Create and migrate the database**

   ```sh
   rails db:create db:migrate
   ```

3. **Run the server**

   ```sh
   rails server
   ```

   The app will be available at `http://localhost:3000`.

4. **Sign up and create posts**

   Visit `/users/new` to create the author account.  Once signed in, you can manage blog posts via the navigation links.

## Deploying with Terraform

The `terraform` directory contains a simple configuration that provisions an EC2 instance, sets up a security group for HTTP/HTTPS/SSH, installs Ruby/Rails via the provided `user_data.sh` script, clones this repository and launches the Rails server.  To use it:

1. **Set variables** – Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and fill in the required fields (VPC ID, subnet ID, SSH key path, AMI ID, etc.).
2. **Initialize and apply**

   ```sh
   cd terraform
   terraform init
   terraform apply
   ```

   Terraform will output the public IP of the instance when complete.  Browse to that IP in your browser (it may take a few minutes for the server to finish bootstrapping).  The first run will also create the database and migrate it.

> **Note:** The provided `user_data.sh` script installs Ruby using RVM and runs the Rails server in production mode.  It assumes you have pushed this code to a public or private Git repository accessible from the EC2 instance.  Replace `<YOUR_REPO_URL>` in the script with the actual repository URL before applying the Terraform plan.

## Structure overview

```
portfolio_site/
├── app/
│   ├── controllers/        # Application and feature controllers
│   ├── models/             # ActiveRecord models (User, Post)
│   └── views/              # ERB templates
├── config/
│   └── database.yml        # Database settings for development/test/production
├── db/
│   └── migrate/            # Migration files to create tables
├── terraform/              # Terraform deployment scripts
└── README.md               # This file
```

This skeleton is not a full Rails distribution – it omits the hundreds of files generated by `rails new` to keep the example concise.  To build a complete application you can either run `rails new` yourself and copy the contents of this directory into the generated app, or use this as a reference for integrating blog functionality into an existing Rails project.