kubectl delete pods --all
kubectl delete service prod-zk-cs
kubectl delete service prod-zk-hs
kubectl delete statefulset prod-zk
kubectl delete service prod-kafka-hs
kubectl delete statefulset prod-kafka
kubectl delete service prod-coordinator-hs
kubectl delete statefulset prod-coordinator
kubectl delete service prod-historical-hs
kubectl delete statefulset prod-historical
kubectl delete service prod-broker-hs
kubectl delete statefulset prod-broker
gcloud container clusters delete ia-production --zone us-east1-d
echo "============================================================="
echo "All containers and compute clusters have been removed. You must manually perform the following checks:"
echo "1. Go to Compute Engine --> Disks and delete the unused persistent disks."
echo "2. Go to Network services --> Load balancing and confirm that loadbalancers have been removed."
echo "-------------------------------------------------------------"
echo "Perform the following two steps to remove the segment deep storage and metadata:"
echo "1. Go to Storage --> SQL and delete the database with prefix ia-prod-*."
echo "2. Go to Storage --> Storage --> Browser --> ia-production-store --> druid and delete the folders named segments and indexing-logs."
echo "-------------------------------------------------------------"
echo "Remember that you should not delete the project, images in container registry, storage buckets and any of the network settings."
echo "============================================================="
