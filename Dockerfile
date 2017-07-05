#FROM 43914423/centos6-base
FROM centos6-base
WORKDIR /root

COPY resource/repo/* /resource/repo/

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch \
 && cp /resource/repo/elasticsearch.repo /etc/yum.repos.d/ \
 && yum clean all \
 && yum makecache \
 && yum install -y elasticsearch kibana logstash java-1.8.0-openjdk java-1.8.0-openjdk-devel

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64

COPY resource/parser-params.sh .
COPY resource/conf-elk/* conf-elk/

RUN cp -fR /root/conf-elk/elasticsearch.yml /etc/elasticsearch/ \
 && chmod 755 /root/conf-*/*.sh \
 && chmod 755 /root/*.sh



CMD /sbin/service sshd start && zsh


# docker build --network=host -t centos6-elk-rpm .
# docker run --rm -d --name c6-master -it --network=hadoop --privileged=true centos6-base