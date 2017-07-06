#FROM 43914423/centos6-base
FROM centos6-base
WORKDIR /root


RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

####################################################################
#  第一种rpm安装走官方 repo库比较慢
#  ** 而且这种方式只支持最新版本的安装

#COPY resource/repo/* /resource/repo/
#RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch \
# && cp /resource/repo/elasticsearch.repo /etc/yum.repos.d/ \
# && yum clean all \
# && yum makecache \
# && yum install -y elasticsearch kibana logstash java-1.8.0-openjdk java-1.8.0-openjdk-devel

####################################################################
#  第二种 下载好对应的安装包，放在局域网络环境的http服务上面
#  ** 下载对应版本到本地安装
#  wget https://artifacts.elastic.co/downloads/kibana/kibana-5.4.3-x86_64.rpm


ENV ELK_VERION="5.4.3"

#RUN mkdir install \
# && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELK_VERION}.rpm -P install
# && wget https://artifacts.elastic.co/downloads/kibana/kibana-${ELK_VERION}-x86_64.rpm -P install
# && wget https://artifacts.elastic.co/downloads/logstash/logstash-${ELK_VERION}.rpm -P install
# && wget https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-${ELK_VERION}.zip -P install

RUN mkdir install \
 && wget http://10.15.110.8/elk/rpm/${ELK_VERION}/elasticsearch-${ELK_VERION}.rpm -P install
 && wget http://10.15.110.8/elk/rpm/${ELK_VERION}/kibana-${ELK_VERION}.rpm -P install
 && wget http://10.15.110.8/elk/rpm/${ELK_VERION}/logstash-${ELK_VERION}.rpm -P install
 && wget http://10.15.110.8/elk/rpm/${ELK_VERION}/x-pack-${ELK_VERION}.zip -P install

RUN rpm --install install/elasticsearch-${ELK_VERION}.rpm
 && rpm --install install/kibana-${ELK_VERION}.rpm
 && rpm --install install/logstash-${ELK_VERION}.rpm

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64

RUN /usr/share/kibana/bin/kibana-plugin install file:///root/install/x-pack-${ELK_VERION}.zip
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///root/install/x-pack-${ELK_VERION}.zip --batch


COPY resource/parser-params.sh .
COPY resource/conf-elk/* conf-elk/

RUN cp -fR /root/conf-elk/elasticsearch.yml /etc/elasticsearch/ \
 && cp -fR /root/conf-elk/jvm.options /etc/elasticsearch/ \
 && cp -fR /root/conf-elk/kibana.yml /etc/kibana/ \
 && chmod 755 /root/conf-*/*.sh \
 && chmod 755 /root/*.sh


CMD /sbin/service sshd start && zsh


# docker build --network=host -t centos6-elk-rpm .
# docker run --rm -d --name c6-master -it --network=hadoop --privileged=true centos6-base