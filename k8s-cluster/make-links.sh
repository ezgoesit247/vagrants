#!/bin/bash

# k8s-cluster

ln -fsn ../empty.sh ./empty.sh
ln -fsn ubuntu.commands.sudo.sh ./master.sh
ln -fsn ubuntu.commands.sudo.sh ./node.sh
ln -fsn ../root_key.sh ./root_key.sh
ln -fsn ubuntu.k8s.sh ./simple.sh
ln -fsn ../box.hosts_sync.sh ./sync.hosts.sh
ln -fsn ../ubuntu.commands.sudo.sh ./ubuntu.commands.sudo.sh
ln -fsn ../ubuntu.k8s.sh ./ubuntu.k8s.sh
ln -fsn ../vagrant_key.sh ./vagrant_key.sh
