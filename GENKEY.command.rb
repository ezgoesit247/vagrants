$GENKEY = <<EOF
date > /etc/vagrant_provisioned_at
ssh-keygen -t rsa -b 4096 -f "/root/.ssh/provisioned_id_rsa.`date +%s`" -q -N ""
EOF
