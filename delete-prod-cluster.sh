kubectl delete pods --all
kubectl delete service prod-zk-cs
kubectl delete service prod-zk-hs
kubectl delete service prod-kafka-hs
kubectl delete service prod-dcoord-hs
kubectl delete service prod-dhist-hs
kubectl delete service prod-dbroker-hs
kubectl delete statefulset prod-zk
kubectl delete statefulset prod-kafka
kubectl delete statefulset prod-dcoord
kubectl delete statefulset prod-dhist
kubectl delete statefulset prod-dbroker
gcloud container clusters delete ia-production --zone us-east1-d
gcloud sql instances delete ia-prod-meta
echo "All containers, databases, compute clusters have been removed. You must manually check and remove any persistent disks and load balancers. Remember that you should not delete the project, images in container registry, and the storage buckets."
