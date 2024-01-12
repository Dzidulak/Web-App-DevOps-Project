# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

## Developments

### Milestone 1

#### *Reverted* New Feature (In feature/add-delivery-date branch)

Added a new column to the order list page that displays the delivery date for each order. By adding this new column a new field in the add order page was added so the the user can add the delivery date the the order.
This feature was updated within the app.py and templates/orders.html files. 

### Milestone 2

#### Containerizing the Web Application

*Creating Dockerfile*

There were 7 steps undertaken to to create this Dockerfile. They were:
1. Creating a file called ```Dockerfile```.
2. Setting the parent image. In this case as the application is using flask the parent/base image is an official Python runtime (python:3.8-slim) using the ```FROM``` command.
3. Setting the working directory using the ```WORKDIR``` command.
4. Copying the application files into the container's working directory set in step using the ```COPY``` command. 
5. Installing dependencies for the container. Using the ```RUN``` command and installing the system dependencies, ODBC driver (for azure sql database), pip, setuptools and the dependencies in the requirements file.
6. Using ```EXPOSE``` command to expose port 5000 as this is the port the Flask app is on. 
7. Setting start up command using ```CMD``` command which will run the application by running app.py file when the container starts running. 

*Building Docker Image*

This saved Docker file is then used to build a docker image using the command ```docker build -t webapp-devops-project```

To check the containerized application is working, it was run locally using the command: ```docker run -p 5000:5000 webapp-devops-project```

With the image running locally it is fine then tag and push the image to Docker Hub. 
This is done using the command: 

```docker tag webapp-devops-project dzidulak/webapp-devops-project:latest``` to tag the image and use  ```docker push``` to push the image to Docker Hub.  

*Docker Image details*

This Docker Image is available on Docker Hub. It's called ```dzidulak/webapp-devops-project``` and has the "latest" tag.

The image can be used by using the command: ```docker pull dzidulak/webapp-devops-project:latest```

### Milestone 3

#### Defining Networking Services with IaaC(Terraform)

This is the first step of setting up a an Azure Kubernetes Service (AKS) cluster using IaaC(Terraform).

I started off by creating different directory which will be used to create each module for the terraform project. The base folder was called ```aks-terraform``` and there were 2 modules within this directory called ```aks-cluster-module``` and ```networking-module```.

The section focusses on the networking module. To start off 3 files are created:

- ```main.tf``` - Held the information holding all he created resources
- ```variables.tf``` - Held the input variables
- ```outputs.tf``` - Held all the output variables

#### *Setting input variables*

3 input variables were set in the variables file. These are variables that were used throughout this module. These variables were:
- ```resource_group_name``` - Name of the Azure Resource Group where the networking resources will be deployed in.
- ```location``` - The Azure region where the networking resources will be deployed to.
- ```vnet_address_space``` - The address space for the Virtual Network (VNet).

#### *Setting main file* 

The resources created in the file were:
- ```azurerm_resource_group```  - The Azure Resource Group.
- ``azurerm_virtual_network`` - The Azure Virtual Network(VNet).
- ``azurerm_subnet`` - subdivision of a Virtual Network and is used to group resources logically
    
    There were 2 subnets created:
    - `control_plane_subnet`
    - `worker_node_subnet`

- `network_security_group`(NSG) - Controls network traffic to and from Azure resources.
- `network_security_rule` - Rules used within the NSG to control traffic

    2 rules were created:
    - `kube-apiserver-rule` - This allows traffic to the kube-apiserver from my public IP using port 443.
    - `ssh` - allow inbound SSH traffic from my public IP using port 22.

#### *Setting outputs variables* 

5 output variables were set in the output variables file. These are variables that are used in other modules. These variables were:

- `vnet_id` - The ID of the created VNet.
- `control_plane_subnet_id` - The ID of the control plane subnet within the VNet.
- `worker_node_subnet_id` - The ID of the worker node subnet within the VNet.
- `networking_resource_group_name` -Name of the networking resources' resource group.
- `aks_nsg_id` - the ID of the Network Security Group (NSG).

### Milestone 4

#### Defining AKS cluster in Terraform

The AKS cluster was defined in the ```aks-cluster-module``` directory and just like to the networking module three files were created.
The input variables, output variables and the main configuration. 

#### *Setting input variables*

The input variables used in this module are:

- ``aks_cluster_name`` - Represents the name of the AKS cluster you wish to create.
- ``cluster_location`` - Specifies the Azure region where the AKS cluster will be deployed to.
- ``dns_prefix`` - Defines the DNS prefix of cluster.
- ``kubernetes_version`` - Specifies which Kubernetes version the cluster will use.
- ``service_principal_client_id`` - Provides the Client ID for the service principal associated with the cluster.
- ``service_principal_secret`` - Supplies the Client Secret for the service principal.

Additionally I added the *output variables* from the *networking module*. This is due to the fact that the networking module establishes 
the networking resources for the AKS cluster.

#### *Setting main file* 

The only resource defined in the main file configuration file is the AKS cluster (``azurerm_kubernetes_cluster``) which was defined with the variables.
Within the aks cluster resource definition the following were defined:

- ``default_node_pool`` - Defines the default node pool for the cluster.
- ``service_principal`` - Provides the authentication details for the AKS cluster

#### *Setting outputs variables* 

5 output variables were set in the output variables file. These variables were:

- ``aks_cluster_name`` - Name of the AKS cluster.
- ``aks_cluster_id`` - ID of the AKS cluster.
- ``aks_kubeconfig`` - Kubeconfig file for interacting with and managing the AKS cluster using kubectl.


## Getting Started

### Prerequisites

For the application to successfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
