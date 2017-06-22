FROM centos6-base
WORKDIR /root

COPY resource/repo/* /resource/repo/

# 163 Mirror
RUN cp /resource/repo/cloudera-cdh5.7.1-ctrip.repo /etc/yum.repos.d/ \
 && ls -l /etc/yum.repos.d \
 && yum clean all \
 && yum makecache \
 && yum install zookeeper hadoop-yarn-resourcemanager hadoop-hdfs-namenode hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce hadoop-client -y \
 && yum clean all

# Install Hbase && zookeeper
RUN yum install hbase-master hbase-regionserver hive zookeeper zookeeper-server -y

COPY resource/cdh-conf/* cdh-conf/

RUN cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster \
 && alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50 \
 && alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster \
 && alternatives --display hadoop-conf \
 && cp -fR /root/cdh-conf/* /etc/hadoop/conf.my_cluster \
 && chmod 755 /root/cdh-conf/*

# To configure local storage directories for use by HDFS
RUN mkdir -p /data/1/dfs/nn /nfsmount/dfs/nn \
 && mkdir -p /data/1/dfs/dn /data/2/dfs/dn \
 && chown -R hdfs:hdfs /data/1/dfs/nn /nfsmount/dfs/nn /data/1/dfs/dn /data/2/dfs/dn \
 && chmod 700 /data/1/dfs/nn /nfsmount/dfs/nn

# To configure local storage directories for use by YARN
RUN mkdir -p /data/1/yarn/local /data/2/yarn/local \
 && mkdir -p /data/1/yarn/logs \
 && chown -R yarn:yarn /data/1/yarn/local /data/2/yarn/local \
 && chown -R yarn:yarn /data/1/yarn/logs


# configure zookeeper
COPY resource/con-zookeeper/* conf-zookeeper/

RUN mkdir -p /var/lib/zookeeper \
 && cp -fR /root/conf-zookeeper/zoo.cfg /etc/zookeeper/conf \
 && chown -R zookeeper /var/lib/zookeeper/

CMD /sbin/service sshd start && zsh


# docker build --network=host -t centos6-cdh-cmd .