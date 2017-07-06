# 用rpm仓库安装Elasticsearch集群

## 集群包含了3个节点

| Container     | HostName  | Component    | Remark                            |
| :-----------  | :------   | :------      |  :------                          |
| es-master     | es-master | es,kibana    | Coordinator ES, Kibana Instance   |
| es-slave1     | es-slave1 | es           | ES DataNode                       |
| es-slave2     | es-slave2 | es           | ES DataNode                       |


## Build
公司环境虚拟机里面的docker默认配置不能上网，可以使用host网络模式 --network=host 编译的时候让container与虚拟机公用同一个网络环境  
或者自建一个docker 网络， 下面使用自建名为hadoop的网络，之后的集群通信也基于该网络
```bash
docker network create --driver=bridge hadoop
docker build --network=host -t centos6-elk-rpm .
```



## 启动两个互联容器
```bash
docker run -d --name=c6-master --hostname=master -it --network=hadoop --privileged=true centos6-base
docker run -d --name=c6-slave1 --hostname=slave1 -it --network=hadoop --privileged=true centos6-base

# Attach to c6-master
docker attach c6-master
# ping c6-slave1 using container name
ping c6-slave1
```
