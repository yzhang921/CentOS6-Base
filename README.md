# 试验阶段的CenotOS Docker基础配置
该Docker镜像
- 配置了网易yum镜像库
- 安装了wget vim jdk1.7 zsh git oh-my-szh等常用环境
- 配置了JAVA_HOME

## Build
公司环境虚拟机里面的docker默认配置不能上网没有多研究高级网络配置，--network=host 编译的时候让container与虚拟机公用同一个网络环境
```bash
docker build --network=host -t 43914413/centos6-ssh .
```


## 启动多个容器并让容器互联，以便进行一些日常中常见的分布式系统验证
参考博客
- [kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker)
- [博客: 基于Docker搭建Hadoop集群之升级版](http://kiwenlau.com/2016/06/12/160612-hadoop-cluster-docker-update/)

>之前的版本使用serf/dnsmasq为Hadoop集群提供DNS服务，由于Docker网络功能更新，现在并不需要了。更新的版本中，使用以下命令为Hadoop集群创建单独的网络:  
docker network create --driver=bridge hadoop  
然后在运行Hadoop容器时，使用”–net=hadoop”选项，这时所有容器将运行在hadoop网络中，它们可以通过容器名称进行通信。

```bash
docker run --rm -d --name c6-master -it --network=hadoop --privileged=true 43914413/centos6-ssh
docker run --rm -d --name c6-slave1 -it --network=hadoop --privileged=true 43914413/centos6-ssh
```

