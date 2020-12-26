#!/bin/bash

# k8s-cluster

ln -fsn ../empty.sh ./empty.sh
ln -fsn hadoop-init.sh ./master.sh
ln -fsn ../root_key.sh ./root_key.sh
ln -fsn ../vagrant_key.sh ./vagrant_key.sh

ln -fsn empty.sh node.sh
ln -fsn empty.sh controller.sh
ln -fsn ../root_key.sh ./root_key.sh
