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

COPY resource/cdh-conf/* cdh-conf/

RUN cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster \
 && alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50 \
 && alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster \
 && alternatives --display hadoop-conf \
 && cp -fR /root/cdh-conf/* /etc/hadoop/conf.my_cluster


CMD /sbin/service sshd start && zsh


# docker build --network=host -t centos6-cdh-cmd .