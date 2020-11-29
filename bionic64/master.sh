sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade \
 && echo "12 4" | sudo apt-get -y -qq install software-properties-common \
 && sudo apt-get -y -qq install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    python3 \
    python3-pip \
    gnupg2 \
    unzip \
    iputils-ping \
    ansible
