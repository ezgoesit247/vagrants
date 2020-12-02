#!/bin/bash

# k8s-cluster-test
###HARD LINK
ln ../k8s-cluster/Vagrantfile

ln -s ../k8s-cluster/empty.sh empty.sh
ln -s ../k8s-cluster/master.sh master.sh
ln -s ../k8s-cluster/node.sh node.sh
ln -s ../k8s-cluster/root_key.sh root_key.sh
ln -s ../k8s-cluster/simple.sh simple.sh
ln -s ../k8s-cluster/sync.hosts.sh sync.hosts.sh
ln -s ../ntp-install.sh ubuntu.k8s-test.sh
ln -s ../k8s-cluster/vagrant_key.sh vagrant_key.sh
ln -s ../k8s-cluster/config_ssh-access.sh
