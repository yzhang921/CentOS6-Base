FROM centos6-base
#FROM 43914423/centos6-base
WORKDIR /root

RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64

RUN mkdir install \
 && wget -q http://10.15.110.8/druid.io/druid-0.10.0-bin.tar.gz -P install \
 && tar -xzf install/druid-0.10.0-bin.tar.gz

ENV DRUID_HOME=/root/druid-0.10.0

COPY resource/conf-druid/ conf-druid/
COPY resource/conf-cdh conf-cdh/

RUN cp -fR conf-cdh/core-site.xml ${DRUID_HOME}/conf/druid/_common/ \
 && cp -fR conf-cdh/hdfs-site.xml ${DRUID_HOME}/conf/druid/_common/ \
 && cp -fR conf-cdh/yarn-site.xml ${DRUID_HOME}/conf/druid/_common/ \
 && cp -fR conf-cdh/mapred-site.xml ${DRUID_HOME}/conf/druid/_common/ \
 && cp -fR conf-druid/druid/ ${DRUID_HOME}/conf/druid/ \
 && mkdir -p /var/log/druid

CMD /sbin/service sshd start && zsh

# docker build --network=host -t centos6-druid .