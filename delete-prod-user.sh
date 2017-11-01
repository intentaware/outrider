if [ $# -ne 1 ]; then
    echo "You must provide a user ID when using delete-prod-user.sh"
    echo "The required format is: sh delete-prod-user.sh unique_user_id"
    exit 1
fi
kubectl delete service prod-user-$1
kubectl delete deployment prod-user-$1
kubectl delete persistentvolumeclaim prod-user-$1-superset
echo "User containers have been deleted. You may want to check and remove persistent disks and load balancers manually."
curl -X POST -H http://prod-dcoord-hs.default.svc.cluster.local:8081/druid/indexer/v1/supervisor/divolte-user-$1/shutdown
echo "Druid has been asked to shutdown indexing job for this user."
