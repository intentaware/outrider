kubectl delete pods --all
kubectl delete service demo-zk-cs
kubectl delete service demo-zk-hs
kubectl delete statefulset demo-zk
kubectl delete service demo-kafka-hs
kubectl delete statefulset demo-kafka
kubectl delete service demo-coordinator-hs
kubectl delete statefulset demo-coordinator
kubectl delete service demo-historical-hs
kubectl delete statefulset demo-historical
kubectl delete service demo-broker-hs
kubectl delete statefulset demo-broker
kubectl delete service demo-user-100
kubectl delete deployment demo-user-100
kubectl delete persistentvolumeclaim demo-user-100-superset
gcloud container clusters delete ia-demo --zone us-east1-d
echo "============================================================="
echo "All containers and compute clusters have been removed. You must manually perform the following checks:"
echo "1. Go to Compute Engine --> Disks and delete the unused persistent disks."
echo "2. Go to Network services --> Load balancing and confirm that loadbalancers have been removed."
echo "-------------------------------------------------------------"
echo "Perform the following two steps to remove the segment deep storage and metadata:"
echo "1. Go to Storage --> SQL and delete the database with prefix ia-demo-*."
echo "2. Go to Storage --> Storage --> Browser --> ia-demo-store --> druid and delete the folders named segments and indexing-logs."
echo "-------------------------------------------------------------"
echo "Remember that you should not delete the project, images in container registry, storage buckets and any of the network settings."
echo "============================================================="
