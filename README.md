# 试验阶段的CenotOS Docker基础配置
该Docker镜像
- 配置了网易yum镜像库
- 安装了wget vim jdk1.7 zsh git oh-my-szh等常用环境
- 配置了JAVA_HOME
- ssh免密互联，关闭了StrictHostKeyChecking，避免第一次连接时的确认提示

## Build
公司环境虚拟机里面的docker默认配置不能上网，可以使用host网络模式 --network=host 编译的时候让container与虚拟机公用同一个网络环境  
或者自建一个docker 网络， 下面使用自建名为hadoop的网络，之后的集群通信也基于该网络
```bash
docker network create --driver=bridge hadoop
docker build --network=host -t centos6-base .
```

## Clone
也可以直接pull镜像
```bash
docker pull 43914423/centos6-base
```


## 启动多个容器并让容器互联，以便进行一些日常中常见的分布式系统验证
参考博客
- [kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker)
- [博客: 基于Docker搭建Hadoop集群之升级版](http://kiwenlau.com/2016/06/12/160612-hadoop-cluster-docker-update/)

>之前的版本使用serf/dnsmasq为Hadoop集群提供DNS服务，由于Docker网络功能更新，现在并不需要了。更新的版本中，使用以下命令为Hadoop集群创建单独的网络:  
docker network create --driver=bridge hadoop  
然后在运行Hadoop容器时，使用”–net=hadoop”选项，这时所有容器将运行在hadoop网络中，它们可以通过容器名称进行通信。


# 使用示例

## 启动两个互联容器
```bash
docker run -d --name=c6-master --hostname=master -it --network=hadoop --privileged=true centos6-base
docker run -d --name=c6-slave1 --hostname=slave1 -it --network=hadoop --privileged=true centos6-base

# Attach to c6-master
docker attach c6-master
# ping c6-slave1 using container name
ping c6-slave1
```

# cdh cluster build base on base image as below
![image](https://user-images.githubusercontent.com/6037522/29016492-3d67e770-7b85-11e7-9420-69eb56d57259.png)


# elk cluster build base on base iamge as below
![image](https://user-images.githubusercontent.com/6037522/29016573-7fd8b328-7b85-11e7-8249-e8c18e6b0165.png)