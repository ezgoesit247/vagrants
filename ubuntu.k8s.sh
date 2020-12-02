sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
&& sudo apt-get -y -qq install \
   apt-transport-https \
   ca-certificates \
   gnupg2 \
   gnupg-agent \
   python3 \
   ansible \
   ntp \
   ntpdate \
   ntpstat \
&& if sudo service ntp status > /dev/null; then sudo service ntp stop; fi \
&& echo "syncing NTP with time.nist.gov..." \
&& sudo ntpdate time.nist.gov && sudo service ntp start \
&& sleep 1 \
&& ntp_tries=10 && ntp_delay_seconds=3 && i=0 \
&& while ! ntpstat; do sleep ${ntp_delay_seconds} && i=`expr ${i} + 1` \
&& if [ ${i} -ge ${ntp_tries} ]; then echo -n "NTP:" && echo bailing && break; fi \
done \
\
&& echo "Adding Docker..." \
\
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add - \
&& sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
\
&& echo "Installing Docker..." \
\
&& sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
&& sudo apt-get -y -qq --allow-unauthenticated install \
   docker-ce \
   docker-ce-cli \
   containerd.io \
\
&& echo "Adding k8s..." \
\
&& echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
&& curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
\
&& echo "Installing k8s..." \
\
&& sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
&& sudo apt-get -y -qq install \
   kubectl \
   kubelet \
   kubeadm \
   kubernetes-cni \
   \
&& echo "Done..."
