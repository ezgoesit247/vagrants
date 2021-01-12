#!/bin/bash

# k8s-cluster

ln -fn ../k8s-cluster/Vagrantfile
ln -fsn ../empty.sh ./empty.sh
ln -fsn empty.sh master.sh
ln -fsn empty.sh node.sh
ln -fsn empty.sh controller.sh
ln -fsn ../root_key.sh ./root_key.sh
ln -fsn ubuntu.k8s.sh ./simple.sh
ln -fsn ../box.hosts_sync.sh ./sync.hosts.sh
ln -fsn ../ubuntu.commands.sudo.sh ./ubuntu.commands.sudo.sh
ln -fsn ../ubuntu.k8s.sh ./ubuntu.k8s.sh
ln -fsn ../vagrant_key.sh ./vagrant_key.sh

# RECURSIVELY LINKS ASSET FILES
dir=_shared_assets && target=./${dir} && src=../k8s-cluster/${dir}
for f in $(ls -1 ${src}/); do if [ ! -d ${src}/${f} ]; then ln ${src}/${f} ./${target}/${f}; fi; done

dir=_shared_assets/techcraz && target=./${dir} && src=../k8s-cluster/${dir}
for f in $(ls -1 ${src}/); do if [ ! -d ${src}/${f} ]; then ln ${src}/${f} ./${target}/${f}; fi; done

echo 0 > CTLR_CT
echo 1 > MSTR_CT
echo 1 > POD_CT
