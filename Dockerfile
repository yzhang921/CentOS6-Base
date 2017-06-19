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

COPY resource/install/* /resource/install/

CMD /sbin/service sshd start && zsh


# docker build --network=host -t centos6-cdh-cmd .