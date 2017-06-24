#FROM centos6-base
FROM 43914423/centos6-base
WORKDIR /root

COPY resource/repo/* /resource/repo/

# 163 Mirror
RUN cp /resource/repo/cloudera-cdh5-local.repo /etc/yum.repos.d/ \
 && ls -l /etc/yum.repos.d \
 && yum clean all \
 && yum makecache \
 && yum install zookeeper hadoop-yarn-resourcemanager hadoop-hdfs-namenode hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce hadoop-client -y \
 && yum clean all

# Install Hbase && zookeeper
RUN yum install hbase-master hbase-regionserver hive zookeeper zookeeper-server -y
RUN yum install -y hive-metastore hive-server2 mysql-server mysql-connector-java

COPY resource/conf-cdh/* conf-cdh/
COPY resource/parser-params.sh .

RUN usermod -a -G hadoop root \
 && usermod -a -G hadoop hbase \
 && usermod -a -G hadoop hive

RUN cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster \
 && alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50 \
 && alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster \
 && alternatives --display hadoop-conf \
 && cp -fR /root/conf-cdh/*.xml /etc/hadoop/conf.my_cluster \
 && cp -fR /root/conf-cdh/slaves /etc/hadoop/conf.my_cluster \
 && chmod 755 /root/conf-cdh/*.sh \
 && chmod 755 ./parser-params.sh

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
COPY resource/conf-zookeeper/* conf-zookeeper/
RUN mkdir -p /var/lib/zookeeper \
 && cp -fR /root/conf-zookeeper/zoo.cfg /etc/zookeeper/conf \
 && chown -R zookeeper /var/lib/zookeeper/ \
 && chmod 755 /root/conf-zookeeper/*.sh


# Configure Hbase
COPY resource/conf-hbase/* conf-hbase/
RUN cp -fR /root/conf-hbase/hbase-site.xml /etc/hbase/conf \
 && cp -fR /root/conf-hbase/regionservers /etc/hbase/conf \
 && chmod 755 /root/conf-hbase/*


# Configure Hive
COPY resource/conf-hive/* conf-hive/
RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar \
 && cp -fR /root/conf-hive/hive-site.xml /etc/hive/conf \
 && chmod 755 /root/conf-hive/*.sh

RUN yum clean all

CMD /sbin/service sshd start && zsh

# docker build --network=host -t centos6-cdh-cmd .