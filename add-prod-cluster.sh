if [ $# -ne 1 ]; then
    echo "You must provide a password for MySQL DB when using add-prod-cluster.sh"
    echo "The required format is: sh add-prod-cluster.sh the_password_you_want_to_set"
    exit 1
fi
gcloud container clusters create ia-production --zone us-east1-d --scopes storage-rw --machine-type n1-standard-2 --num-nodes 3
gcloud sql instances create ia-prod-meta --tier=db-f1-micro --region=us-east1
gcloud sql users set-password root % --instance ia-prod-meta --password $1
gcloud sql users create proxyuser cloudsqlproxy~% --instance=ia-prod-meta --password=$1
gcloud sql databases create druid --instance=ia-prod-meta --charset=utf8
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=druid-sql-client.json
kubectl create secret generic cloudsql-db-credentials --from-literal=username=proxyuser --from-literal=password=$1
kubectl apply -f prod-cluster/prod-zookeeper.yaml
kubectl apply -f prod-cluster/prod-kafka.yaml
kubectl apply -f prod-cluster/prod-dcoord.yaml
kubectl apply -f prod-cluster/prod-dhist.yaml
kubectl apply -f prod-cluster/prod-dbroker.yaml
