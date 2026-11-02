#set -x
#!/bin/bash


echo
echo "========================================================================"
echo "📊  CLOUD-NATIVE DEVOPS BOOTSTRAP - FINAL SYSTEM SUMMARY"
echo "========================================================================"
echo "This script summarizes the end-to-end infrastructure deployment."
echo "It dynamically extracts cluster access endpoints, storage health states,"
echo "and administrative credentials for the provisioned platform layer."
echo "========================================================================"
echo


echo
echo "------------------------------------------"
echo "KUBERNETES CONTROL PLANE IP ADDRESS"
IP=$(curl -s ifconfig.me)
echo $IP


echo
echo "------------------------------------------"
echo "SERVER SSH LOGIN METHOD"
echo ssh root@$IP


echo
echo "------------------------------------------"
echo "KUBECTL ALLOWED USER"
echo $(whoami)


echo
echo "------------------------------------------"
echo "------------------------------------------"
echo "JENKINS WEB PORT"
PORT=$(kubectl get svc jenkins-service -n jenkins -o jsonpath="{.spec.ports[0].nodePort}")
echo $PORT


echo
echo "------------------------------------------"
echo "JENKINS WEB LINK"
echo http://$IP:$PORT


echo
echo "------------------------------------------"
echo "JENKINS WEB USER"
echo admin


echo
echo "------------------------------------------"
echo "JENKINS WEB PASSWD"
PASSWD=$(kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo)
echo $PASSWD


echo
echo "------------------------------------------"
echo "------------------------------------------"
echo "ARGOCd WEB PORT"
PORT_A=$(kubectl get svc argocd-server -n argocd -o jsonpath="{.spec.ports[0].nodePort}")
echo $PORT_A


echo
echo "------------------------------------------"
echo "ARGOCd WEB LINK"
echo http://$IP:$PORT_A


echo
echo "------------------------------------------"
echo "ARGOCd WEB USER"
echo admin


echo
echo "------------------------------------------"
echo "ARGOCd WEB PASSWD"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > passwd_a.txt
cat passwd_a.txt


echo
echo "------------------------------------------"
echo "------------------------------------------"
echo "NGINX_DEMO WEB LINK (DEPLOYED BY JENKINS PUSH API BUILD JOB ON CEPH STORAGE)"
echo http://$IP:30080 # port 30080 is hardcoded in the nginx.xml script


echo
echo "------------------------------------------"
echo "------------------------------------------"
echo "CEPH STATUS"
CEPHS=$(kubectl -n rook-ceph exec deploy/rook-ceph-tools -- bash -c "ceph status")
echo "$CEPHS"


exit 0
