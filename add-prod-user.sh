if [ $# -ne 1 ]; then
    echo "You must provide a user ID when using add-prod-user.sh"
    echo "The required format is: sh add-prod-user.sh unique_user_id"
    exit 1
fi
sed -e "s;%USER%;$1;g" user-template/prod-user.yaml > prod-user/prod-user-$1.yaml
sed -e "s;%USER%;$1;g" user-template/spec-user.yaml > prod-user/spec-user-$1.yaml
kubectl apply -f prod-user/prod-user-$1.yaml
USERIP="$(kubectl describe services prod-user-$1 | grep "LoadBalancer Ingress" | sed -E 's/LoadBalancer Ingress:[[:space:]]+//')"
echo "User $1 Loadbalancer IP is ${USERIP}"
curl -X POST -H 'Content-Type: application/json' -d @prod-user/spec-user-$1.json http://prod-dcoord-hs.default.svc.cluster.local:8081/druid/indexer/v1/supervisor
echo "The user's indexing job has been submitted to Druid."
