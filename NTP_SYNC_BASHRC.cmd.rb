BASHRC = "echo 'function color  { echo -n \"\$(tput setaf $1;tput setab $2)${3}$(tput sgr 0) \"; }
function green  { color 4 2 \"${*}\"; }
function yellow { color 0 3 \"${*}\"; }
function red { color 0 1 \"${*}\"; }
grep \"DISTRIB_DESCRIPTION\" /etc/lsb-release
#echo \"Doing NTP sync...\"
#if ! ntpstat > /dev/null 2>&1
# then service ntp stop && ntpdate time.nist.gov && service ntp start
#   ntp_tries=8 && ntp_delay_seconds=4 && i=0
#   while ! ntpstat
#     do sleep \${ntp_delay_seconds} && i=\`expr ${i} + 1\`
#     if [ \${i} -ge \${ntp_tries} ]
#       then yellow \"NTP:\" && echo bailing && break
#     fi
#   done
#fi
if ntpstat > /dev/null 2>&1
 then green \"NTP Synchronization Status:\" && ntpstat
 else red \"NTP:\" && echo \"not synchronized\"
fi'"

$NTP_SYNC_BASHRC = <<EOF
#{BASHRC}  >> /root/.bashrc
#{BASHRC}  >> /home/vagrant/.bashrc
EOF
