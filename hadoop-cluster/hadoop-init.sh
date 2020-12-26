JAVA_HOME="/jdk1.8"
M2_HOME="/maven"
HADOOP_HOME="/hadoop"

echo export JAVA_HOME="$(echo $JAVA_HOME)"  >> /etc/bash.bashrc
echo export M2_HOME="$(echo $M2_HOME)"  >> /etc/bash.bashrc
echo export HADOOP_HOME="$(echo $HADOOP_HOME)"  >> /etc/bash.bashrc
echo export PATH="\$PATH:\${JAVA_HOME}/bin:\${HADOOP_HOME}/bin:\${M2_HOME}/bin" >> /etc/bash.bashrc

echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo 3|update-alternatives --config editor > /dev/null
useradd -rm -s /bin/bash -d /home/hadoop -U -u 1002 hadoop
cp -rp /root/.ssh ~hadoop
chown -R hadoop:hadoop ~hadoop/.ssh

echo 'alias ls="ls -ltrA --color=auto"' >> ~vagrant/.bashrc 2>/dev/null
echo 'alias ls="ls -ltrA --color=auto"' >> ~hadoop/.bashrc 2>/dev/null
echo 'alias ls="ls -ltrA --color=auto"' >> /root/.bashrc 2>/dev/null

if [ ! -d ${JAVA_HOME} ]; then mkdir ${JAVA_HOME} && tar -zxf /vagrant/software/hadoop/jdk-8u271-linux-x64.tar.gz \
   -C ${JAVA_HOME} --strip-components 1; fi
if [ ! -d ${M2_HOME} ]; then mkdir ${M2_HOME} && tar -zxf /vagrant/software/hadoop/apache-maven-3.6.3-bin.tar.gz \
   -C ${M2_HOME} --strip-components 1; fi
if [ ! -d ${HADOOP_HOME} ]; then mkdir ${HADOOP_HOME} && tar -zxf /vagrant/software/hadoop/hadoop-2.10.1.tar.gz \
   -C ${HADOOP_HOME} --strip-components 1; fi
chown -R root:root ${JAVA_HOME}
chown -R root:root ${M2_HOME}
chown -R hadoop:hadoop ${HADOOP_HOME}
sed -i "s|\${JAVA_HOME}|${JAVA_HOME}|" $HADOOP_HOME/etc/hadoop/hadoop-env.sh

echo "export HADOOP_VERSION=\`${HADOOP_HOME}/bin/hadoop version|grep Hadoop|awk '{print \$2}'\`" >> /etc/bash.bashrc
echo 'export CLASSPATH="${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-client-core-${HADOOP_VERSION}.jar:${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-client-common-${HADOOP_VERSION}.jar:${HADOOP_HOME}/share/hadoop/common/hadoop-common-${HADOOP_VERSION}.jar:${HADOOP_HOME}/lib/*"' >> /etc/bash.bashrc

hadooptmpdir="/app/hadoop/tmp"
cat>$HADOOP_HOME/etc/hadoop/core-site.xml<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
      <name>hadoop.tmp.dir</name>
      <value>${hadooptmpdir}</value>
      <description>Parent directory for other temporary directories.</description>
   </property>
   <property>
      <name>fs.defaultFS</name>
      <value>hdfs://localhost:54310</value>
      <description>The name of the default file system. </description>
   </property>
</configuration>
EOF

mkdir /app && sudo mkdir /app/hadoop && sudo mkdir /app/hadoop/tmp
chown -R hadoop:hadoop /app
chmod 750 -R /app
cat>/etc/profile.d/hadoop.sh<<EOF
export HADOOP_HOME=${HADOOP_HOME}
EOF
chown hadoop:hadoop /etc/profile.d/hadoop.sh
sudo cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml

mapreducejobtracker="localhost:54311"
cat>$HADOOP_HOME/etc/hadoop/mapred-site.xml<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
      <name>mapreduce.jobtracker.address</name>
      <value>${mapreducejobtracker}</value>
      <description>MapReduce job tracker runs at this host and port.</description>
   </property>
</configuration>
EOF

#sudo su - -c "cat >$HADOOP_HOME/etc/hadoop/mapred-site.xml"<<EOF
#<?xml version="1.0" encoding="UTF-8"?>
#<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
#<configuration>
#   <property>
#      <name>mapreduce.jobtracker.address</name>
#      <value>localhost:54311</value>
#      <description>MapReduce job tracker runs at this host and port.</description>
#   </property>
#</configuration>
#EOF


dfsdatadir="/home/hadoop/hdfs"
cat>$HADOOP_HOME/etc/hadoop/hdfs-site.xml<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
      <name>dfs.replication</name>
      <value>1</value>
      <description>Default block replication.</description>
   </property>
   <property>
      <name>dfs.datanode.data.dir</name>
      <value>${dfsdatadir}</value>
   </property>
</configuration>
EOF
mkdir $dfsdatadir
chown -R hadoop:hadoop $dfsdatadir
chmod 750 $dfsdatadir

#$HADOOP_HOME/bin/hdfs namenode -format \
#   && $HADOOP_HOME/sbin/start-dfs.sh \
#   && $HADOOP_HOME/sbin/start-yarn.sh

echo 'function hadoop_init {
   $HADOOP_HOME/bin/hdfs namenode -format
   $HADOOP_HOME/sbin/start-dfs.sh
   $HADOOP_HOME/sbin/start-yarn.sh
   jps|grep -E "Node|Manager"
}' >> /etc/bash.bashrc

#jps|grep -E 'Node|Manager'

#$HADOOP_HOME/sbin/stop-dfs.sh \
#   && $HADOOP_HOME/sbin/stop-yarn.sh

echo 'function hadoop_stop {
   s="To stop hadoop"
   s="${s}\n$HADOOP_HOME/sbin/stop-dfs.sh"
   s="${s}\n$HADOOP_HOME/sbin/stop-yarn.sh"
   echo -e "$s"
}' >> /etc/bash.bashrc
