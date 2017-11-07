if [ $# -ne 2 ]; then
    echo "You must provide a name and password for MySQL DB when using add-prod-cluster.sh"
    echo "The required format is: sh add-prod-cluster.sh db_name the_password_you_want_to_set"
    exit 1
fi
gcloud container clusters create ia-production --zone us-east1-d --scopes storage-rw --machine-type n1-standard-4 --num-nodes 3
gcloud sql instances create ia-prod-$1 --tier=db-f1-micro --region=us-east1
gcloud sql users set-password root % --instance ia-prod-$1 --password $2
gcloud sql users create proxyuser cloudsqlproxy~% --instance=ia-prod-$1 --password=$2
gcloud sql databases create druid --instance=ia-prod-$1 --charset=utf8
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=druid-sql-client.json
kubectl create secret generic cloudsql-db-credentials --from-literal=username=proxyuser --from-literal=password=$2
sed -e "s;%SQL%;$1;g" prod-cluster/prod-coordinator-template.yaml > prod-cluster/prod-coordinator.yaml
kubectl apply -f prod-cluster/prod-zookeeper.yaml
kubectl apply -f prod-cluster/prod-kafka.yaml
kubectl apply -f prod-cluster/prod-coordinator.yaml
kubectl apply -f prod-cluster/prod-historical.yaml
kubectl apply -f prod-cluster/prod-broker.yaml
