# Build the image
docker build -t 0gis0/origin .

# Push the image to Docker Hub
docker push 0gis0/origin

# Your Unified Streaming Platform Licence Key
USP_LICENSE_KEY=<YOUR_USP_KEY>

# Run the container locally with a local folder mounted
docker run -p 80:80 \
-v ${PWD}:/var/www/unified-origin \
-e USP_LICENSE_KEY=$USP_LICENSE_KEY \
-e LOG_LEVEL=debug \
0gis0/origin

# Now lets create an AKS
RESOURCE_GROUP="unified-streaming-platform"
LOCATION="northeurope"
AKS_NAME="UnifiedStreaming"

#Log in Azure
az login

#Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

#Azure Kubernetes Service
az aks create -g $RESOURCE_GROUP -n $AKS_NAME --node-count 1 --generate-ssh-keys
az aks get-credentials -g $RESOURCE_GROUP -n $AKS_NAME

kubectl get nodes

#Create a secret with the USP licence key
#Create a filename called "key" and paste the usp licence key
kubectl create secret generic usp-licence --from-file=key

# Create the rest of the resources
kubectl apply -f aks.yaml

#Download tears-of-steel locally
wget http://repository.unified-streaming.com/tears-of-steel.zip
#Unzip it
unzip tears-of-steel.zip -d tears-of-steel

#Upload all files on VoD to the Persistent Volume created

#Get the svc IP and see if it works