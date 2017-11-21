if [ $# -ne 2 ]; then
    echo "You must provide a name and password for MySQL DB when using add-demo-cluster.sh"
    echo "The required format is: sh add-demo-cluster.sh db_name the_password_you_want_to_set"
    exit 1
fi
gcloud container clusters create ia-demo --zone us-east1-d --scopes storage-rw --machine-type n1-standard-4 --num-nodes 1 --preemptible
gcloud sql instances create ia-demo-$1 --tier=db-f1-micro --region=us-east1
gcloud sql users set-password root % --instance ia-demo-$1 --password $2
gcloud sql users create proxyuser cloudsqlproxy~% --instance=ia-demo-$1 --password=$2
gcloud sql databases create druid --instance=ia-demo-$1 --charset=utf8
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=../druid-sql-client.json
kubectl create secret generic cloudsql-db-credentials --from-literal=username=proxyuser --from-literal=password=$2
sed -e "s;%SQL%;$1;g" demo-coordinator-template.yaml > demo-coordinator.yaml
kubectl apply -f demo-zookeeper.yaml
kubectl apply -f demo-kafka.yaml
kubectl apply -f demo-coordinator.yaml
kubectl apply -f demo-historical.yaml
kubectl apply -f demo-broker.yaml
kubectl apply -f demo-user-100.yaml
kubectl proxy &
curl -X POST -H 'Content-Type: application/json' -d @spec-user-100.json http://localhost:8001/api/v1/namespaces/default/pods/demo-coordinator-0:8081/proxy/druid/indexer/v1/supervisor
echo "The user's indexing job has been submitted to Druid."
sleep 120s
USERIP="$(kubectl describe services demo-user-100 | grep "LoadBalancer Ingress" | sed -E 's/LoadBalancer Ingress:[[:space:]]+//')"
echo "User 100 loadbalancer IP is ${USERIP}"
