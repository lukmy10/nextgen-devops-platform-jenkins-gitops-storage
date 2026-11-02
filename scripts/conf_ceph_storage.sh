#set -x
#!/bin/bash


cd ~


echo
echo "------------------------------------------"
echo "APPLY CEPH BLOCK POOL YAML"
kubectl apply -f cephblockpool.yaml


echo
echo "------------------------------------------"
echo "APPLY STORAGE CLASS YAML"
kubectl apply -f cephstorageclass.yaml


echo
echo "------------------------------------------"
echo "APPLY PERSISTENT VOLUME CLAIM YAML"
kubectl apply -f pvc_nginx.yaml -n jenkins


echo
echo "------------------------------------------"
echo "SLEEP 45"
sleep 45


echo
echo "------------------------------------------"
echo "GET PERSISTENT VOLUME CLAIMS"
kubectl get pvc -n jenkins


exit 0