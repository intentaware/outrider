if [ $# -ne 1 ]; then
    echo "You must provide a user ID when using add-prod-user.sh"
    echo "The required format is: sh add-prod-user.sh unique_user_id"
    exit 1
fi
sed -e "s;%USER%;$1;g" user-template/prod-user.yaml > prod-user/prod-user-$1.yaml
sed -e "s;%USER%;$1;g" user-template/spec-user.json > prod-user/spec-user-$1.json
kubectl apply -f prod-user/prod-user-$1.yaml
kubectl proxy &
curl -X POST -H 'Content-Type: application/json' -d @prod-user/spec-user-$1.json http://localhost:8001/api/v1/namespaces/default/pods/prod-coordinator-0:8081/proxy/druid/indexer/v1/supervisor
echo "The user's indexing job has been submitted to Druid."
sleep 120s
USERIP="$(kubectl describe services prod-user-$1 | grep "LoadBalancer Ingress" | sed -E 's/LoadBalancer Ingress:[[:space:]]+//')"
echo "User $1 loadbalancer IP is ${USERIP}"
