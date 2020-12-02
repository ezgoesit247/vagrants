$GENKEY = <<EOF
ssh-keygen -t rsa -b 4096 -f "/root/.ssh/provisioned_id_rsa.`openssl rand -hex 12`" -q -N ""
ssh-keygen -t rsa -b 4096 -f "/home/vagrant/.ssh/provisioned_id_rsa.`openssl rand -hex 12`" -q -N ""
EOF
