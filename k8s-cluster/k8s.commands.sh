## MASTER AS VAGRANT
#CREATE CONTROL PLANE WITH CALICO POD NETWORK
LOG="cluster_initialized.log"
api="10.96.0.20"
network="10.96.0.0/16"
NAMESPACE="kube-system"
YAML="https://docs.projectcalico.org/v3.9/manifests/calico.yaml"

sudo su - -c "kubeadm reset -f 2>&1 | tee -a ${LOG} &&  rm -rf ~vagrant/.kube"
sudo su - -c "kubeadm init --apiserver-advertise-address=${api}    --pod-network-cidr=${network}" 2>&1

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo su - vagrant -c "kubectl create -f ${YAML}" 2>&1
kubeadm token create --print-join-command > ./joincluster.sh
sudo mv ./joincluster.sh /joincluster.sh

sudo su - -c "kubeadm token create --print-join-command > /joincluster.sh" 2>&1

watch kubectl get nodes
watch kubectl get pods -n ${NAMESPACE}

## WORKER AS VAGRANT
scp -o StrictHostKeyChecking=no master.k8s-cluster.dev.anytown.usa:/joincluster.sh /joincluster.sh

## CONTROLLER AS VAGRANT
ssh-master "kubectl get all --all-namespaces --output=wide"
ssh-master "kubectl get pods -n ${NAMESPACE}"

ssh-master "kubectl get nodes"
node=node1
ssh-master "kubectl drain ${node}  --ignore-daemonsets --delete-emptydir-data"
ssh-master "kubectl delete node node1"

ssh-pods 'sudo su - -c "scp -o StrictHostKeyChecking=no master.k8s-deployment.dev.anytown.usa:/joincluster.sh /joincluster.sh"'
ssh-pods 'sudo su - -c "/bin/bash /joincluster.sh"'

nodelist="node1 node2"
for node in ${nodelist}; do ssh-master "kubectl drain ${node}  --ignore-daemonsets --delete-emptydir-data && kubectl delete node ${node}"; done

ssh-pods 'sudo su - -c "kubeadm reset -f"'
ssh-master 'sudo su - -c "kubeadm reset -f'

# ADMIN COMMANDS
kubectl config view
kubectl get all --all-namespaces --output=wide
kubectl describe all --all-namespaces
kubectl get nodes
kubectl get pods
kubectl get pods -w -l app=nginx
kubectl get pv task-pv-volume
kubectl describe pod/wordpress-69cd75f4f-fr482


### ENAABLE SINGLE NODE CLUSTER ###
kubectl taint nodes --all node-role.kubernetes.io/master-
### ### ### ###
kubectl exec -it task-pv-pod -- /bin/bash

kubectl drain <node-name>
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
kubectl delete node <node-name>
kubeadm reset

l="wordpress wordpress-mysql" && \
for deployment in ${l}; do kubectl delete deployment ${deployment};done

l="wordpress wordpress-mysql" && \
for service in ${l}; do kubectl delete service ${service};done

l="wp-pv-claim mysql-pv-claim" && \
for pvc in ${l}; do kubectl delete pvc ${pvc};done

l="wp-pv-claim mysql-pv-claim" && \
for pv in ${l}; do kubectl delete pv ${pv};done

kubectl delete statefulset ${s}
