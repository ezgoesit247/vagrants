$SYNC_HOSTS_FILE = <<EOF
> /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts
echo 'for ip in 10.250.0.1 10.250.0.2 10.250.0.100 10.250.0.101; do
    ssh-keyscan -H ${ip} >> /root/.ssh/known_hosts; done
cp -f /root/.ssh/known_hosts /home/vagrant/.ssh/known_hosts \
   && chown vagrant:vagrant /home/vagrant/.ssh/known_hosts \
   && chmod 600 /home/vagrant/.ssh/known_hosts
' > /root/sync.hosts.sh
chmod 700 /root/sync.hosts.sh
/root/sync.hosts.sh
EOF
