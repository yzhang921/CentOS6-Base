FROM centos6-base
#FROM 43914423/centos6-base
WORKDIR /root

RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64

RUN mkdir install \
 && wget http://192.168.50.204:8027/cdh/duird.io/druid-0.10.0-bin.tar.gz -P install \
 && tar -xzf install/druid-0.10.0-bin.tar.gz \

ENV DRUID_HOME=/root/druid-0.10.0

COPY conf/ conf-druid/
COPY ../resource/conf-cdh/ conf-cdh/

RUN cp -fR conf-cdh/core-site.xml ${DRUID_HOME}/conf/ \
 && cp -fR conf-cdh/hdfs-site.xml ${DRUID_HOME}/conf/ \
 && cp -fR conf-cdh/yarn-site.xml ${DRUID_HOME}/conf/ \
 && cp -fR conf-cdh/mapred-site.xml ${DRUID_HOME}/conf/ \
 && mkdir -p /var/log/druid
