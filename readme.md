Scalable and Secure Web Application Architecture
## Terraform: AWS Three-Tier Architecture
    In this project, I created a three-tier architecture leveraging Terraform modules to make the process easily repeatable and reusable. My architecture resides in a custom VPC. The Architectural Diagram gives an overview of the setup
    The public Subnet have a bastion host and NAT gateway. The bastion host serves as the access point to the underlying infrastructure. The NAT Gateway will allow the private subnets to access updates from the internet.
    The private subnet can be divided into two teir to house the web application. The Web Tier for the front end application and the App tier for the backend application, I created an internet facing load balancer to direct internet traffic to an autoscaling group in the private subnets, along with a backend autoscaling group for our backend application. I created a script to install the apache webserver in the frontend, and a script to install Node.js in the backend.
    Another layer of private subnets was created in the database subnet to host a RDS MySQL database which i eventually accessed using Node.js.

## The Architectural Diagram 
![Architectural_Diagram.png](Architectural_Diagram.png)
## Pre-requists

1. Craete a Secret and store secret value manually on AWS Console
![img_14.png](img_14.png)
2. Update terraform.tfvars file with respect to your secret credentials
3. Create Key pair
![img_8.png](img_8.png)


## Github Workflow Action
For this project i made use of github workflow action authenticating to my aws account using OpenID connect with an IAM role for my CI/CD,in doing that i created an s3 bucket to keep track of my terraform state  to destroy environment and apply environment inorder not to create multiple environment why testing
![img_7.png](img_7.png)

   
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute"></a> [compute](#module\_compute) | ./compute | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./database | n/a |
| <a name="module_loadbalancing"></a> [loadbalancing](#module\_loadbalancing) | ./loadbalancing | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./networking | n/a |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_ip"></a> [access\_ip](#input\_access\_ip) | n/a | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | n/a | `string` | n/a | yes |
| <a name="input_dbpassword"></a> [dbpassword](#input\_dbpassword) | n/a | `string` | n/a | yes |
| <a name="input_dbuser"></a> [dbuser](#input\_dbuser) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_endpoint"></a> [database\_endpoint](#output\_database\_endpoint) | n/a |
| <a name="output_load_balancer_endpoint"></a> [load\_balancer\_endpoint](#output\_load\_balancer\_endpoint) | n/a |



## Testing

If you go into your AWS console, you should be able to see the VPC and subnets, internet gateway, route tables and associations, EC2 instances running in the proper locations, load balancers, and RDS database.

1.  vpc
![img.png](img.png)

2. Subnets
![img_1.png](img_1.png)
3. EC2 instances: Only the Bastion will have a public IP address
![img_2.png](img_2.png)
4. Load Balancer and Target Group
![img_3.png](img_3.png)
![img_4.png](img_4.png)
5. Database
![img_5.png](img_5.png)

If we copy the load balancer endpoint we got from our Terraform output (you can find it in the github action log), and place it in the search bar, we will see the message we specified in our script for the Apache webserver.

![img_6.png](img_6.png)


![img_15.png](img_15.png)
If we refresh the page, we should see the IP address from the other instance in our frontend autoscaling group.
![img_16.png](img_16.png)

## testing out the infrastructure.

You will need to use the keypair to SSH into the bastion host. Locate the public IP address of your Bastion Instance in the console:

    ssh -i "Key_pair" ec2-user@<Public_IP_Address>

For example, my file path included looks like this:

![img_9.png](img_9.png)

-> Important

If you want to SSH into the backend application instances, you will need the SSH agent if you are using Windows PowerShell. You should be able to SSH into the frontend, then backend private subnets as well. Simply use the private IP when going into the private subnets. You will need to bring your keypair with you to each instance. Here is the command you would use to do so when entering the Bastion host:
    
    ssh -A ec2-user@<Public_IP_Address>

or simply copying the keypair of the private subnet server inside the bastion host
    scp -i "key_name" "private_server_key_name" ec2-user@50.16.96.220<Public_IP_Address>:<the path to paste file>

![img_12.png](img_12.png)
![img_17.png](img_17.png)

now we can use the keypair to access our private server with their private IP
In order to get into one of the backend application instances, we will go back to the Bastion, and then go to the backend:

Now we will install the MySQL driver to access our AWS database using Node.js. Use the command npm install mysql. Then we will make a JavaScript file to connect with the database:

![img_10.png](img_10.png)

Go in to edit the file using vim, or your preferred text editor:

    var mysql = require('mysql');
    var con = mysql.createConnection({
    host: "database_endpoint from Terraform Output",
    user: "dbuser from tfvars file",
    password: "dbpassword from secret Manager"
    });
    con.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
    });
Make sure to :wq 

![img_11.png](img_11.png)

we will use the command node yourfile.js

![img_13.png](img_13.png)

