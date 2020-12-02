sudo apt-get -y -qq update && sudo apt-get -y -qq install \
   ntp \
   ntpdate \
   ntpstat \
&& if sudo service ntp status > /dev/null; then sudo service ntp stop; fi \
&& echo "syncing NTP with time.nist.gov..." \
&& sudo ntpdate time.nist.gov && sudo service ntp start \
&& ntp_tries=10 && ntp_delay_seconds=2 && i=0 \
&& while ! ntpstat; do sleep ${ntp_delay_seconds} && i=`expr ${i} + 1` \
   && if [ ${i} -ge ${ntp_tries} ]; then echo -n "NTP:" && echo bailing && break; fi \
done
