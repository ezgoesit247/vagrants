IPLIST = ""
admin_ip = ['10.250.0.10','10.250.0.20']
node_ip = ['10.250.0.51','10.250.0.52']
host_ip = admin_ip + node_ip
host_ip.each do |ip| IPLIST+="#{ip} " end
$SYNC_HOSTS_FILE = <<EOF
echo '#!/bin/bash
> /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts
for ip in #{IPLIST}; do
ssh-keyscan -H ${ip} >> /root/.ssh/known_hosts; done
cp -f /root/.ssh/known_hosts /home/vagrant/.ssh/known_hosts \
   && chown vagrant:vagrant /home/vagrant/.ssh/known_hosts \
   && chmod 600 /home/vagrant/.ssh/known_hosts
' > /etc/init.d/synchosts.sh \
&& chmod 755 /etc/init.d/synchosts.sh \
&& ln -sfn /etc/init.d/synchosts.sh /etc/rc3.d/S01synchosts
EOF
