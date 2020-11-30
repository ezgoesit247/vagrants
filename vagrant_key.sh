cat /root/.ssh/authorized_keys >> /home/vagrant/.ssh/authorized_keys \
\
   && cp -f /root/.ssh/id_rsa /home/vagrant/.ssh/id_rsa \
   && chown vagrant:vagrant /home/vagrant/.ssh/id_rsa \
   && chmod 600 /home/vagrant/.ssh/id_rsa \
\
   && cp -f /root/.ssh/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub \
   && chown vagrant:vagrant /home/vagrant/.ssh/id_rsa.pub \
   && chmod 644 /home/vagrant/.ssh/id_rsa.pub
