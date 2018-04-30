#!/bin/bash
#Create a Storage Account
export AZURE_STORAGE_ACCOUNT=brunostoracc
export RG=brunoresourcegroup
#Creating a Resource Group
az group create -n $RG -l eastus

#Creating a Storage Account
az storage account create \
    --location eastus \
    --name  $AZURE_STORAGE_ACCOUNT \
    --resource-group $RG \
    --sku Standard_LRS

#Obtaining Storage Account Connection String
export SA_CONN=`az storage account show-connection-string -g $RG -n $AZURE_STORAGE_ACCOUNT -o tsv`

#Building Docker container
docker build -t brusmx/azfunctionpython:1.0 .
#Run docker 
docker run -p 8080:80 -it -e AzureWebJobsStorage=$SA_CONN <image_name>