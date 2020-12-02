for box in `ls ./.vagrant/machines/`; do ssh root@${box}.k8s-cluster "hostname -f" 2> /dev/null; done
