sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
 && echo "12 4" | sudo apt-get -y -qq install software-properties-common \
 && sudo apt-get -y -qq install \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    gnupg-agent \
    python3 \
    python3-pip \
    unzip \
    iputils-ping \
    ntp \
    ntpdate \
    ntpstat \
 && if sudo service ntp status > /dev/null; then sudo service ntp stop; fi \
 && echo "syncing NTP with time.nist.gov..." \
 && if ! sudo service ntp status > /dev/null; then sudo ntpdate time.nist.gov && sudo service ntp start; fi \
 && sleep 3 \
   && ntp_tries=8 && ntp_delay_seconds=4 && i=0 \
   && while ! ntpstat; do sleep ${ntp_delay_seconds} && i=`expr ${i} + 1` \
     && if [ ${i} -ge ${ntp_tries} ]; then echo -n "NTP:" && echo bailing && break; fi \
   done \
\
 && echo "Doing Ansible..." && sleep 3 \
 && sudo apt-add-repository --yes --update ppa:ansible/ansible
 && sudo apt install ansible
\
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add - \
 && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
\
 && echo "Doing Docker..." && sleep 3 \
\
 && sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
 && sudo apt-get -y -qq install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
\
 && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
 && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
\
 && echo "Doing k8s..." && sleep 3 \
\
 && sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
 && sudo apt-get -y -qq install \
    kubectl \
    kubelet \
    kubeadm \
    kubernetes-cni \
\
 && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3|sudo bash \
 && helm repo add stable https://charts.helm.sh/stable \
 && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
 && if ! command -v aws > /dev/null; then echo "Installing AWS CLI..." && unzip -q awscliv2.zip && sudo ./aws/install; fi \
 && echo 'function showcolors { for bg in `seq 0 9`; do for fg in `seq 0 9`; do echo -n "`expr $fg` `expr $bg`: " && color `expr $fg` `expr $bg` "Tyler & Corey"; echo; done; done }'  >> ~vagrant/.bashrc   && echo 'alias colors=showcolors' >> ~vagrant/.bashrc   && echo 'function color  { echo -n "$(tput setaf $1;tput setab $2)${3}$(tput sgr 0) "; }' >> ~vagrant/.bashrc   && echo 'function green  { color 4 2 "${*}"; }' >> ~vagrant/.bashrc   && echo 'function yellow { color 0 3 "${*}"; }' >> ~vagrant/.bashrc   && echo 'function red { color 0 1 "${*}"; }' >> ~vagrant/.bashrc   && echo 'function blue   { color 6 4 "${*}"; }' >> ~vagrant/.bashrc   && echo 'function cyan   { color 4 6 "${*}"; }' >> ~vagrant/.bashrc   && echo 'function grey   { color 0 7 "${*}"; }' >> ~vagrant/.bashrc   && echo 'function pass   { echo; echo "$(green PASS: ${*})"; echo; }' >> ~vagrant/.bashrc   && echo 'function warn   { echo; echo "$(yellow PASS: ${*})"; echo; }' >> ~vagrant/.bashrc   && echo 'function fail   { echo; echo "$(red FAIL: ${*})"; echo; }' >> ~vagrant/.bashrc   && echo 'function info   { echo; echo "$(grey INFO: ${*})"; echo; }' >> ~vagrant/.bashrc \
 && echo|cat>>~vagrant/.bashrc<<EOF
grep "DISTRIB_DESCRIPTION" /etc/lsb-release
echo "Doing NTP sync..."
if ! ntpstat > /dev/null 2>&1
  then sudo service ntp stop && sudo ntpdate time.nist.gov && sudo service ntp start
    ntp_tries=8 && ntp_delay_seconds=4 && i=0
    while ! ntpstat
      do sleep \${ntp_delay_seconds} && i=\`expr \${i} + 1\`
      if [ \${i} -ge \${ntp_tries} ]
        then yellow "NTP:" && echo bailing && break
      fi
    done
fi
if ntpstat > /dev/null 2>&1
  then green "NTP Synchronization Status:" && ntpstat
  else red "NTP:" && echo "not synchronized"
fi

if command -v java > /dev/null 2>&1; then blue "java:"; java -version; else yellow "No Java"; fi; echo
if command -v javac > /dev/null 2>&1; then blue "javac:"; javac -version; else yellow "No JDK"; fi; echo
if command -v mvn > /dev/null 2>&1; then blue "maven"; mvn --version; else yellow "No Maven"; fi; echo

if command -v kubelet > /dev/null 2>&1; then cyan "kubelet:"; kubelet --version; else yellow "No kubelet"; fi;
if command -v kubectl > /dev/null 2>&1; then cyan "kubectl:"; kubectl version --short --client; else yellow "No kubectl"; echo; fi;
if command -v kubeadm > /dev/null 2>&1; then cyan "kubeadm:"; kubeadm version --output short; else yellow "No kubeadm"; echo; fi;
if command -v helm > /dev/null 2>&1; then cyan "helm:"; helm version --short; else yellow "No helm"; echo; fi;
if command -v docker > /dev/null 2>&1; then cyan "docker"; docker --version; else yellow "No Docker"; echo; fi;
sudo docker run --rm hello-world 2> /dev/null | grep -o "Hello from Docker!"
if command -v eksctl > /dev/null 2>&1; then cyan "eksctl:"; eksctl version ; else yellow "No EKSCtl"; fi; echo
if command -v aws > /dev/null 2>&1; then cyan "AWS_CLI:"; /usr/local/bin/aws --version; else yellow "AWS CLI"; echo; fi;

EOF
