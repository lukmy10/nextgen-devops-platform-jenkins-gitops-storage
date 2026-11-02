#set -x
#!/bin/bash


echo
echo "------------------------------------------"
echo "CREATE ARGOCd NAMESPACE"
kubectl create namespace argocd


echo
echo "------------------------------------------"
echo "INSTALL ARGOCd"
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


sleep 15


echo
echo "------------------------------------------"
echo "CHECK ARGOCd PODS"
kubectl get pods -n argocd


echo
echo "------------------------------------------"
echo "PATCH ARGOCd SERVICES TO THE NODEPORT"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'


echo
echo "------------------------------------------"
echo "CHECK ARGOCd SERVICES"
kubectl get svc -n argocd


echo
echo "------------------------------------------"
echo "GET ARGOCd ADMIN PASSWORD"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


exit 0