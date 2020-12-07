if [ -z $1 ]; then for box in `ls ./.vagrant/machines/`; do echo -e "\t${box}:" && ssh root@${box}.k8s-cluster "hostname -f && /etc/init/synchosts.sh" && echo; done
else ssh root@${1}.k8s-cluster "hostname -f && /etc/init/synchosts.sh"; fi
