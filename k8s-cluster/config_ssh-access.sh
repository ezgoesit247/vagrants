for box in `ls ./.vagrant/machines/`; do ssh root@${box}.k8s-cluster "/etc/init/synchosts.sh"; done
