if [ $# -ne 1 ]; then
    echo "You must provide a user ID when using delete-prod-user.sh"
    echo "The required format is: sh delete-prod-user.sh unique_user_id"
    exit 1
fi
USERIP="$(kubectl describe services prod-user-$1 | grep "LoadBalancer Ingress" | sed -E 's/LoadBalancer Ingress:[[:space:]]+//')"
kubectl delete service prod-user-$1
kubectl delete deployment prod-user-$1
kubectl delete persistentvolumeclaim prod-user-$1-superset
kubectl proxy &
curl -X POST http://localhost:8001/api/v1/namespaces/default/pods/prod-coordinator-0:8081/proxy/druid/indexer/v1/supervisor/divolte-user-$1/shutdown
echo "============================================================="
echo "Druid has been asked to shutdown indexing job for this user."
echo "User $1 loadbalancer IP was ${USERIP}"
echo "User containers have been deleted. You must manually perform the following checks:"
echo "1. Go to Compute Engine --> Disks and delete the unused persistent disks."
echo "2. Go to Network services --> Load balancing and confirm that loadbalancer has been removed."
echo "============================================================="
