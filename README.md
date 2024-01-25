# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Developments](#developments)
- [Project architecture diagram](#project-architecture-diagram)
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

## Developments

The following milestones show how I created an end-to-end devops pipeline for this application. 

### **Milestone 1**: Version control

#### *Reverted* New Feature (In feature/add-delivery-date branch)

Added a new column to the order list page that displays the delivery date for each order. By adding this new column a new field in the add order page was added so the the user can add the delivery date the the order.
This feature was updated within the app.py and templates/orders.html files. 

### **Milestone 2**: Containerizing the Web Application

#### Creating Dockerfile

There were 7 steps undertaken to to create this Dockerfile. They were:
1. Creating a file called ```Dockerfile```.
2. Setting the parent image. In this case as the application is using flask the parent/base image is an official Python runtime (python:3.8-slim) using the ```FROM``` command.
3. Setting the working directory using the ```WORKDIR``` command.
4. Copying the application files into the container's working directory set in step using the ```COPY``` command. 
5. Installing dependencies for the container. Using the ```RUN``` command and installing the system dependencies, ODBC driver (for azure sql database), pip, setuptools and the dependencies in the requirements file.
6. Using ```EXPOSE``` command to expose port 5000 as this is the port the Flask app is on. 
7. Setting start up command using ```CMD``` command which will run the application by running app.py file when the container starts running. 

#### Building Docker Image

This saved Docker file is then used to build a docker image using the command ```docker build -t webapp-devops-project```

To check the containerized application is working, it was run locally using the command: ```docker run -p 5000:5000 webapp-devops-project```

With the image running locally it is fine then tag and push the image to Docker Hub. 
This is done using the command: 

```docker tag webapp-devops-project dzidulak/webapp-devops-project:latest``` to tag the image and use  ```docker push``` to push the image to Docker Hub.  

#### Docker Image details

This Docker Image is available on Docker Hub. It's called ```dzidulak/webapp-devops-project``` and has the "latest" tag.

The image can be used by using the command: ```docker pull dzidulak/webapp-devops-project:latest```

### **Milestone 3**: Defining Networking Services with IaaC(Terraform)

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

### **Milestone 4**: Defining AKS cluster in Terraform

The AKS cluster was defined in the ```aks-cluster-module``` directory and just like to the networking module three files were created.
The input variables, output variables and the main configuration. 

#### Setting input variables

The input variables used in this module are:

- ``aks_cluster_name`` - Represents the name of the AKS cluster you wish to create.
- ``cluster_location`` - Specifies the Azure region where the AKS cluster will be deployed to.
- ``dns_prefix`` - Defines the DNS prefix of cluster.
- ``kubernetes_version`` - Specifies which Kubernetes version the cluster will use.
- ``service_principal_client_id`` - Provides the Client ID for the service principal associated with the cluster.
- ``service_principal_secret`` - Supplies the Client Secret for the service principal.

Additionally I added the *output variables* from the *networking module*. This is due to the fact that the networking module establishes 
the networking resources for the AKS cluster.

#### Setting main file

The only resource defined in the main file configuration file is the AKS cluster (``azurerm_kubernetes_cluster``) which was defined with the variables.
Within the aks cluster resource definition the following were defined:

- ``default_node_pool`` - Defines the default node pool for the cluster.
- ``service_principal`` - Provides the authentication details for the AKS cluster

#### Setting outputs variables

5 output variables were set in the output variables file. These variables were:

- ``aks_cluster_name`` - Name of the AKS cluster.
- ``aks_cluster_id`` - ID of the AKS cluster.
- ``aks_kubeconfig`` - Kubeconfig file for interacting with and managing the AKS cluster using kubectl.

### Milestone 5: Creating AKS cluster in Terraform

#### Defining main configuration & Creating a AKS cluster with terraform. 

The main configuration was created in the ``aks-terraform`` directory.

#### *Setting input variables*

##### Getting credentials

In the main configuration 4 azure account details are need:``client_id``, ``client_secret``, ``subscription_id`` and ``tenant_id``.
These credentials are obtained through the Azure CLI. First I obtained the the subscription ID and this is obtained by to login to Azure CLI using 
```
az login
``` 
then using the 
```
az account list --output table
``` 
which will show the subscription ID. 

The next step was to create a service principal which is an identity that helps apps/automated solutions like this to interact with azure resources. To create a service principal the following command is used:

```
az ad sp create-for-rbac --name {service-principal-name} --role contributor --scopes subscriptions/{your-subscription-id}
```

Where ``{service-principal-name}`` is the name chosen for the service principal and ``{your-subscription-id}``. This command will create the service principal and will reveal the ``client_id``, ``client_secret``, ``subscription_id`` and ``tenant_id`` in a JSON in the CLI.

As the ``client_id`` and ``client_secret`` are sensitive data they were set as environment variables  

##### Input variable definition

Only the the the ``client_id`` and ``client_secret`` were defined in the input variables and "sensitive" field was set to "true" for both variables. 

#### *Setting main configuration*
- provider

The first step in the main configuration file is to set the providers fields. The first terraform field sets the configuration to *"azurerm"* which is used for Azure resources. Then set the provider which is where the service principal details obtained above are defined.

Next is setting up the 2 modules that have already been defined (the networking module & aks the cluster module) both modules were set up using the syntax below:
```
module "<module-name>" {
  source = "<directory-of-module>"

  # Input variables for the networking module
  ...
  ...
}
```
As shown above the module requires the source of the module defined, then the input variable for those modules defined. 

##### accessing aks cluster.
After deploying the aks cluster, To access it you can use the command below which will fetch the kubeconfig and automatically merge it into your local ~/.kube/config file, which is the default location for kubeconfig. 
```
az aks get-credentials --resource-group <your-resource-group> --name <your-aks-cluster-name>
```
This will allow you to interact with the aks cluster using kubectl commands. 

### ** Milestone 6**: Kubernetes Deployment to AKS 

In this section I create a kubernetes manifest file. This file describes the desired state of the the kubernetes object. 
To start a yaml file named ``application-manifest.yaml``. This file holds the information of how I desire my kubernetes object to look and therefore holds the information for the deployment and the service. 
The normal syntax for files are as shown below
```
apiVersion: ..
kind: ...
metadata:
  ...
spec:
  ...
```

#### Deployment

To start ``apiVersion:``  was set to app/v1 which just shows this as the first version of the deployment. Then to specify that I'm defining a deployment, I make sure the ``kind`` field is set to *"Deployment"*. Then within the ``metadata`` fields i name the deployment "flask-app-deployment" and this acts as a central reference for managing the containerized application. 
The ``spec:`` field holds teh rest of the design of the deployment and the following setting are defined in this field:
- ``replicas: 2`` - This specifies that the application should concurrently run on two replicas within the AKS cluster, allowing for scalability and high availability.
- Adding a ``selector`` field and using the ``matchLables`` section I defined the app the with label ``app: flask-devops-webapp`` which is used as a unique identifier and allows Kubernetes to identify which pods the Deployment should manage.
- This label is also used in the next metadata section within the template field (pod template) and this is is used to mark the pods created by the Deployment, establishing a clear connection between the pods and the application being managed.
- Defining the container being used. I simply defined the docker image that is holding the application which is on Docker Hub and exposing port 5000 for communication within the AKS cluster.
- The final step was setting the deployment strategy. The chosen strategy was Rolling Updates which facilitating seamless application updates and makes minimizes downtime for users.

#### Service

With the deployment manifest configured, I configured the service manifest in the same file facilitate internal communication within the AKS cluster using the ``---`` command.
The steps taken to configure this were:
- Specifying the ``kind:`` as *"Service"* and naming the service "flask-app-service".
- The selector label is set to the same label used in the deployment manifest ("flask-devops-webapp") which guarantees that the traffic is efficiently directed to the appropriate pods, maintaining seamless internal communication within the AKS cluster.
- Configured the service to use the TCP protocol on port 80 for internal communications and the ``targetPort`` is set to 5000 which is the same as the port exposed by the container in the deployment manifest. 
- Finally, I set the service type to "ClusterIP", designating it as an internal service within the AKS cluster. 

#### Testing & Validation

This application is an internal tool designed for the company's employees and is not intended for external users and given its internal nature, I assessed the now deployed deployment by performing port forwarding to a local machine using the ```kubectl port-forward <pod-name> 5000:5000``` command. 

To test and validate the application I accessed the application locally using the the url: ``http://127.0.0.1:5000`` and I checked every feature of the application and made sure it was everything was working as expected. The features tested were:
- The order list is displaying the information as expected on each page.
- Switching between the order list and the add order page making sure that there are no problems there. 
- Adding order through the add order page and making sure they are shown on the order list page. 
- Adding different values to make sure invalid details are not inputted.

#### Possible distribution plans

There may be point were the team members/internal company users will want access to the application. In this case I would probably use a change the service manifest to use a *"load balancer"* which provide an efficient way to distribute incoming requests across the nodes in the Kubernetes cluster. By giving the team members and other internal company members the ip address & port to the application they can easily access the application using a web browser. This also skips the hassle of port forwarding for others. 

In a time where I would want to share the application to external users it would be better to use an Ingress using HTTPS in the service manifest as this would be better for handling external web traffic and will be more secure. 

### **Milestone 7**: CI/CD Pipeline with Azure DevOps

The first step to create a CI/CD pipeline in Azure DevOps is creating a project within Azure DevOps. 
And then within the "pipelines" tab after the project is created create a "new pipeline" using GitHub as the source control system where your application code is hosted. 
After configuring the git hub connection I chose this github repo which holds all the source code and other vital documents that will be used for the pipeline's automation. 

#### Azure pipeline file

After choosing the repository it was time to start the creation of the pipeline .yml file. In Azure Devops there are templates that can be used to start the pipeline build. I used the Starter pipeline template to start and edited it to my liking. 

#### Build pipeline creation 

Before editing anything I needed to create a service connection between Azure DevOps and my Docker Hub account which holds the application image. 
This allows for seamless integration of the CI/CD pipeline with the Docker Hub container registry. 

This was done by creating the access token on Docker Hub and then on Azure Devops add a new "Docker Registry" service connection using the my docker hub username and the created access token. 
Now that the service connection is created, the build pipeline can create the docker image and push the image to Docker Hub seamlessly. 

Now back in the azure-pipeline.yml file, I added a task in the steps field to build and push the application to Docker Hub. This is easy to do using the add task feature in Azure Devops and this helps tyo add the following code to the file.
```
- task: Docker@2
  inputs:
    containerRegistry: 'Docker Hub'
    repository: 'dzidulak/webapp-devops-project'
    command: 'buildAndPush'
    Dockerfile: '**/Dockerfile'
    tags: 'latest'
```
And this code basically uses the "buildAndPush" command to build and push a docker image, from the Dockerfile at the directory supplies in the repository used in for the pipeline, to Github.  

To check this was created fine, I saved and ran the pipeline. After seeing that it ran smoothly, I checked Docker Hub to see when the last push was made. 

#### Release pipeline creation 

Now that the build pipeline is sorted, its time to create the release pipeline. 

A service connection is also needed for the release pipeline to help establish a secure link between the CI/CD pipeline and the AKS cluster. This will enable seamless deployments and effective management. 
The Kubernetes service connection was created in a settings using my azure subscription as it is an AKS cluster. 

With with the service connection set, I then went back into the pipeline.yaml file to configure the release pipeline by adding "Deploy to Kubernetes" task to deploy the application onto the aks cluster. I then added the following task:
```
- task: KubernetesManifest@1
  inputs:
    action: 'deploy'
    connectionType: 'azureResourceManager'
    azureSubscriptionConnection: <my-azure-subscription>
    azureResourceGroup: 'networking-rg'
    kubernetesCluster: 'terraform-aks-cluster'
    manifests: 'application-manifest.yaml'
```
This task deploys the application from the application manifest file in the repository to my aks cluster with the name of the cluster and the resource group specified. The connection type is also "azureResourceManager" as an aks cluster is a azure resource. 

With the release pipeline configured, I saved and ran this file to perform the full pipeline. So it builds and pushes the docker image and then deploys the application onto the aks cluster earlier created. To check that this deployment was successful I checked the aks cluster to see the if the pods have been created. Then I used port forwarding to access the application locally and test the application's functionality. 

### **Milestone 8**: AKS Cluster Monitoring 

Monitoring the aks cluster is essential as it allows for me to identify and address issues in real time, optimizing resource usage and making data-driven decisions. 

The first step before anything was to enable container insights which is a  tool for collecting real-time in-depth performance and diagnostic data anf this will allow me to efficiently monitor the application performance and troubleshoot issues. This was done in the insights section under monitoring in the aks cluster being monitored in the Azure portal. 

#### Metrics Explorer charts

Metrics explorer charts help visually track different aspects of the aks cluster. These were created in metrics page under the monitoring in the aks cluster.
The charts created by making sure the scope was the name of the aks cluster, the aggregation is average and the following metrics:

- Average Node CPU Usage - Shows the CPU usage of your AKS cluster's nodes which helps ensure efficient resource allocation and detect potential performance issues.
  - Below is a screenshot of the chart. The CPU usage percentage is on y axis and the time (using 24hr clock) is shown on the x axis. It shows that only 8% of the nodes cpu is being used.
  ![Average Node CPU Usage Screenshot](screenshots/Average%20Node%20CPU%20Usage.png)

- Average Pod Count - Shows the average number of pods running in your AKS cluster which is key for evaluating the cluster's capacity and workload distribution.
  - Below is a screenshot of the chart. The number of pods running is ready state are on y axis and the time (using 24hr clock) is shown on the x axis. It shows that only 16 pods were in ready state.
  ![Average Pod Count Screenshot](screenshots/Average%20Pod%20Count.png)

- Used Disk Percentage - Shows how much disk space is being utilized which is critical to prevent storage-related issues.
  - Below is a screenshot of the chart. The used disk space percentage is on y axis and the time (using 24hr clock) is shown on the x axis. It shows that only 8% of the disk space is being used. 
  ![Used Dis Percentage Screenshot](screenshots/Used%20Disk%20Percentage.png)

- Bytes Read and Written per Second - Provides insights into data transfer rates which helps identify potential performance bottlenecks. 
  - This chart was created by adding two metics (Avg Bytes Read per Second & Avg Bytes Written per Second) together on one chart using the add metrics feature found at the top of the metics page. 
  - Below is a screenshot of the chart.The average bytes written/read per second are on y axis and the time (using 24hr clock) is shown on the x axis. It shows that only 16 pods were currently 
  ![Bytes Read and Written per Second Screenshot](screenshots/Bytes%20Read%20and%20Written%20per%20Second.png)

#### Log Analytics

Log Analytics is query based tool that help produce different insights into different aspects of the aks cluster.
The Log Analytics is found in the logs section under monitoring in the aks cluster on the Azure portal.
It uses Kusto Query Language (KQL) with some pre-made queries for different insights for the aks cluster and these queries can also edited in the query window. 

For this aks cluster I performed and saved 5 queries to analyse  and they were: 
- Average Node CPU Usage Percentage per Minute - This captures data on node-level usage at a granular level, with logs recorded per minute which helps detect performance concerns and efficiently allocate resources.  
  - This was a pre-built query found in the "alerts" section and it produced the following results:
  ![Average Node CPU Usage Percentage per Minute Screenshot](screenshots/Screenshot%202024-01-24%20165606.png)
  - Each row in the results represents the average node CPU usage within one-minute.

- Average Node Memory Usage Percentage per Minute - This, similarly to the CPU usage percentage, helps track memory usage at node level helping detect memory-related performance concerns and efficiently allocate resources 
  - This was a pre-built query found in the "alerts" section and it produced the following results:
  ![Average Node Memory Usage Percentage per Minute Screenshot](screenshots/Screenshot%202024-01-24%20165717.png)
  - Each row in the results represents the average node memory usage within one-minute.

- Pods Counts with Phase - This the count of pods with different phases which offers insights into pod lifecycle and helps ensure the cluster's workload is appropriately distributed.
  - This was a pre-built query found in the "availability" section and it produced the following results:
  ![Pods Counts with Phase Screenshot](screenshots/Screenshot%202024-01-24%20172107.png)
  - Each row in the results represents the number of pods in various phases within one-minute.

- Find Warning Value in Container Logs - This helps detect issues or errors within the containers, allowing for prompt troubleshooting and issues resolution. 
  - I edited the pre-built query "Find a value in Container Logs Table" under the "Container" by assigning "warning" to the FindString variable. 
  - When I ran this query no warning were found. 
  - But in the case of were warnings are found, each row in the result section represents an instance where the specific keyword was found in the container logs.

- Monitoring Kubernetes Events - This helps track events like pod scheduling, scaling activities, and errors, which is essential for tracking the overall health and stability of the cluster. 
  - When I ran this query no events were found. 
  - In the case where events are found, each row in the result section represents an instance where specific Kubernetes events were found in the container logs. 

#### Configuring the alarms

Setting alarms help detect and address issues promptly, reducing the risk of disruptions and optimizing the performance of your applications.

The alarm setup is found in the alerts section under monitoring. And all the alarms are found in the alert rules tag on the top ribbon. 
I created a new alert rule for the "Disk Used Percentage". The specific configurations were:
  - Signal name = Disk Used Percentage 
  - Threshold value = 90% - If the disk usd percentage passes 90% an alert will bve sent. 
  - Check every = 5 min - How often the condition should be checked. 
  - Loopback period = 15 min - How far back the rule should look when evaluating alert conditions.

Then I created an Action group which is collections of notification preferences and actions that can be bundled together to form a comprehensive response to an alert. This was used to specify how the alert is sent. 
This was created by naming the action group and choosing it's resource group, subscription and region. Then I specified the notification type to be Email/SMS messages/Push/Voice as I wanted the alerts to come by email so I highlighted email field and typed in my email and saving that action group and the alarm. 

I also edited the preset alerts (CPU usage and memory working set percentage alerts) to have threshold value to be 80% and be in the same action group as the disk used percentage rule.  

####  Responding to the alarms

When it comes to responding to these alerts, I would first look at at my resources to see if there are any un used recourses that are not being used and try to clear up space. 
If this does help, I would have to scale up the infrastructure with more replicas a or adding more memory to the infrastructure. 

### **Milestone 8**: AKS Integration with Azure Key Vault for Secrets Management

#### Azure Key Vault Setup
Azure Key Vault provides a secure store for secrets. It helps securely store keys, passwords, certificates, and other secrets. 

I created a Azure Key vault by going to the Key Vault homepage and click create. Then I chose the appropriate subscription, resource group, region and gave the ky vault a meaningful name and clicking create. 

The permissions then need to be assigned. This is done in the Access control (IAM) section in the key vault. I then added a "Key Vault Administrator" role assignment to the key vault and made myself the member to that role which ensures secure and efficient management of Key Vault. 

#### Storing secrets in Key Vault

The purpose of the key vault in this application was to store the database credentials. Previously the **server name**, **database name**, **username** and the **password** were stored in the application code but this is poor security. By using the the key vault all these credentials are secure while in the aks cluster. 
Each credential was created in the secrets section under objects in the key vault. In the secrets section, I used Generate/Import to add each credential giving it a name and entering the value secret.  

#### Integrate AKS with Key Vault

To integrate the aks cluster with the key vault, the first step is to enable the managed identity. A managed identity is a security feature in Azure that eliminates the need for developers to manually manage credentials which simplifies the authentication and authorization processes for applications and services. 
I enabled a system-assigned managed identity which created directly on specific Azure resources where only the specified resource can use this managed identity to request tokens from Microsoft Entra ID and the identity is automatically deleted when the associated Azure resource is deleted.
The followiing command enables the this system-assigned identity:
```
az aks update --resource-group <resource-group> --name <aks-cluster-name> --enable-managed-identity
```
Then I used the following command to get information about the managed identity created for the AKS cluster:
```
az aks show --resource-group <resource-group> --name <aks-cluster-name> --query identityProfile
```
I took note of the "clientId" and used it in the following command to assign the "Key Vault Secrets Officer" RBAC role to the Managed Identity of an AKS cluster:
```
az role assignment create --role "Key Vault Secrets Officer" --assignee <managed-identity-client-id> --scope /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.KeyVault/vaults/{key-vault-name}
```
 This grants AKS the necessary permissions to interact securely with Azure Key Vault. 

#### Modifications to the application code
Now that every is set the application can use the vault to hold the database credentials and still be securely used in the application.

I first needed to pip install the "azure-identity" and "azure-keyvault-secrets" libraries. These libraries provide a set of tools for secure authentication and access management within Azure services therefore simplifying the process of integrating identity-related functionalities into your applications, ensuring secure interactions with Azure resources.

In the application code I imported the "ManagedIdentityCredential" from "azure.identity" and "SecretClient" from "azure.keyvault.secrets". 
After I declared the Vault URI which is the is the unique address used to access and interact with the resources stored within the key vault and is found on the overview page of the key vault.
Then I set the secret client with the managed identity using the following code:
```
key_vault_url = "https://<your-key-vault-name>.vault.azure.net/"
credential = ManagedIdentityCredential()
secret_client = SecretClient(vault_url=key_vault_url, credential=credential)
```
"key_vault_url" is the Vault URI.

I then accessed the value of each secret using the following code:
```
secret = secret_client.get_secret("secret-name").value
```
Where "secret-name" is the name of secret in the key vault. This will alow the code to use the values form the key vault to log into the database.

## Project architecture diagram

This diagram shows the structure of the whole project
![Project architecture diagram Screenshot](screenshots/UML%20diagram%20for%20the%20architecture.png)

## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
