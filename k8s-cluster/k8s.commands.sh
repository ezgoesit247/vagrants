## MASTER AS VAGRANT
ip="10.96.0.20"
network="10.96.0.0/16"
NAMESPACE="kube-system"
YAML="kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml"

sudo su - -c "kubeadm reset -f 2>&1 | tee -a ${LOG} &&  rm -rf ~vagrant/.kube"
sudo su - -c "kubeadm init --apiserver-advertise-address=${api}    --pod-network-cidr=${network}" 2>&1

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo su - vagrant -c ${YAML} 2>&1
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

kubectl drain <node-name>
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
kubectl delete node <node-name>
kubeadm reset
