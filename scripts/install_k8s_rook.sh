#set -x
#!/bin/bash


echo
echo "------------------------------------------"
echo "CHECK USER NAME"
whoami | tee $USER
echo $USER


#echo
#echo "------------------------------------------"
#echo "CREATE ROOK DIRECTORY"
#mkdir -p /home/$USER/rook
#chmod 777 /home/$USER/rook
#ls -la /home/$USER | grep -i rook


echo
echo "------------------------------------------"
echo "ROOK GIT CLONE"
cd ~
git clone --single-branch --branch v1.21.0 https://github.com/rook/rook.git


echo
echo "------------------------------------------"
echo "GOTO ROOK DIRECTORY"
cd /home/$USER/rook/deploy/examples


echo
echo "------------------------------------------"
echo "CREATE CRDS COMMON CSI-OPERATOR"
kubectl create -f crds.yaml -f common.yaml -f csi-operator.yaml


echo
echo "------------------------------------------"
echo "SLEEP 90"
sleep 90


echo
echo "------------------------------------------"
echo "CREATE OPERATOR"
kubectl create -f operator.yaml


echo
echo "------------------------------------------"
echo "SLEEP 90"
sleep 90


echo
echo "------------------------------------------"
echo "GET ROOK-CEPH PODS"
kubectl -n rook-ceph get pod


echo
echo "------------------------------------------"
echo "SLEEP 30"
sleep 30


echo
echo "------------------------------------------"
echo "UPDATE CLUSTER.YAML WITH TRUE VALUE"
sed -i 's/allowMultiplePerNode: false/allowMultiplePerNode: true/' cluster.yaml


echo
echo "------------------------------------------"
echo "CREATE CLUSTER"
kubectl create -f cluster.yaml


echo
echo "------------------------------------------"
echo "SLEEP 90"
sleep 90


echo
echo "------------------------------------------"
echo "GET CEPHCLUSTER WATCH"
kubectl wait --for=condition=Ready cephcluster --all -n rook-ceph --timeout=10m


echo
echo "------------------------------------------"
echo "SLEEP 30"
sleep 30


echo
echo "------------------------------------------"
echo "CREATE TOOLBOX"
kubectl create -f toolbox.yaml


echo
echo "------------------------------------------"
echo "ROLLOUT TOOLBOX"
kubectl -n rook-ceph rollout status deploy/rook-ceph-tools


#kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash


exit 0