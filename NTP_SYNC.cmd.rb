$NTP_SYNC = <<EOF
echo '#!/bin/bash

if ! ntpstat > /dev/null 2>&1
   then service ntp stop && ntpdate time.nist.gov && service ntp start
   ntp_tries=8 && ntp_delay_seconds=4 && i=0
   while ! ntpstat
     do sleep ${ntp_delay_seconds} && i=`expr ${i} + 1`
     if [ ${i} -ge ${ntp_tries} ]
       then yellow "NTP:" && echo bailing && break
     fi
   done
fi' > /etc/init.d/ntpsync.sh \
   && chmod 755 /etc/init.d/ntpsync.sh \
   && ln -sfn /etc/init.d/ntpsync.sh /etc/rc3.d/S01ntpsync
EOF
