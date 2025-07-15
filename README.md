# AzDevops
Web app deployment using terraform


This project is a set up of how to deploy Azure a Web app connected to a Cosmos DB using Terraform 

The terraform workspace consists of two files:
a. main.tf 
b. variables.tf 


The main.tf consists of the root module configuration file that defines the desired state of the web app deployed in an app service plan, CosmosDB complete with a database and container

The Web app code is deployed from a publicly available Github repository that enables us to use a no-hands approach and concentrate on the purpose of this project which is integration of Az Devops and terraform
The repository that hosts the code is https://github.com/Azure-Samples/cosmos-dotnet-core-todo-app?tab=readme-ov-file
