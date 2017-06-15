FROM centos:6.9
WORKDIR /root

# 163 Mirror
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
    && curl -o /etc/yum.repos.d/CentOS6-Base-163.repo http://mirrors.163.com/.help/CentOS6-Base-163.repo \
    && yum clean all \
    && yum makecache

# Base Util
RUN yum install iputils openssh-server openssh-clients git vim wget java-1.7.0-openjdk java-1.7.0-openjdk-devel -y

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# install on-my-zsh
RUN yum install zsh -y \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ENV JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64

CMD /sbin/service sshd start && zsh


# docker build --network=host -t 43914413/centos6-ssh .
# docker run --rm --name c6-ssh -it --privileged=true 43914413/centos6-ssh