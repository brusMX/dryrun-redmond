#!/bin/bash
export AZURE_STORAGE_ACCOUNT=brunostoracc
export RG=brunoresourcegroup
export DOCKER_ACCOUNT=brusmx
export APP_SVC_NAME=brusno
export FUNCTION_NAME=brunofunc


#Creating a Resource Group
az group create -n $RG -l eastus

#Creating a Storage Account
az storage account create \
    --location eastus \
    --name  $AZURE_STORAGE_ACCOUNT \
    --resource-group $RG \
    --sku Standard_LRS

# Obtaining Storage Account Connection String
export SA_CONN=`az storage account show-connection-string -g $RG -n $AZURE_STORAGE_ACCOUNT -o tsv`

# Building Docker container
docker build -t $DOCKER_ACCOUNT/azfunctionpython:1.0 .

# Run docker 
docker run -p 8080:80 -it -e AzureWebJobsStorage=$SA_CONN microsoft/azure-functions-python3.6:v2.0.11651-alpha
docker run -p 8080:80 -it -e AzureWebJobsStorage=$SA_CONN $DOCKER_ACCOUNT/azfunctionpython:1.0 

export CURRENT_FUNCTION_NAME=$FUNCTION_NAME-${RANDOM:0:4} 
# ## NONE OF THESE WORKS WITHOUTH DOCKER RUNNING!
# # Publish to Azure functions
# # Create an App Service plan
# az appservice plan create --name $APP_SVC_NAME -g $RG --sku S1 --is-linux

# # Create Function 

# az functionapp create --name $CURRENT_FUNCTION_NAME --storage-account  $AZURE_STORAGE_ACCOUNT  --resource-group $RG \
# --plan $APP_SVC_NAME --deployment-container-image-name microsoft/azure-functions-python3.6:v2.0.11651-alpha

# #Configure the function
# az functionapp config appsettings set --name $CURRENT_FUNCTION_NAME \
# --resource-group $RG \
# --settings AzureWebJobsDashboard=$SA_CONN \
# AzureWebJobsStorage=$SA_CONN

# #Image: microsoft/azure-functions-python3.6:v2.0.11651-alpha

# # Test the function
# curl http://$CURRENT_FUNCTION_NAME.azurewebsites.net/api/HttpTriggerJS1?name=$USER

#USING https://github.com/Azure/azure-functions-docker-python-sample/wiki/Getting-started-using-Functions-Core-Tools

#Deploying
func azure login
# Set your subscription if you have more than one
func azure account set <subscription id>
func azure functionapp publish $CURRENT_FUNCTION_NAME
