#!/bin/bash

test=""
if grep test>>/dev/null<<<`echo ${PWD##*/}`; then test="-test"; fi
purpose=".k8s-cluster${test}"
domain=".dev${test}.anytown.usa"

for box in controller master node1 node2; do echo && echo "Connecting to ${box}${test} as root testing ssh:" && ssh root@${box}${purpose} 'for ip in 10.250.0.10 10.250.0.20 10.250.0.51 10.250.0.52; do ssh root@${ip} "echo -n root@ && hostname -f"; done && for ip in 10.250.0.10 10.250.0.20 10.250.0.51 10.250.0.52; do ssh vagrant@${ip} "echo -n vagrant@ && hostname -f"; done'; done
