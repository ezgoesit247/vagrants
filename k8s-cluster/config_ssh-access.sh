if [ -z $1 ]; then for box in `ls ./.vagrant/machines/`; do ssh root@${box}.k8s-cluster "/etc/init/synchosts.sh"; done
else ssh root@${1}.k8s-cluster "/etc/init/synchosts.sh"; fi
