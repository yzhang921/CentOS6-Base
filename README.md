# 用rpm仓库安装Elasticsearch集群

## 1 集群包含了3个节点

| Container     | HostName  | Component    | Remark                            |
| :-----------  | :------   | :------      |  :------                          |
| es-master     | es-master | es,kibana    | Coordinator ES, Kibana Instance   |
| es-slave1     | es-slave1 | es           | ES DataNode                       |
| es-slave2     | es-slave2 | es           | ES DataNode                       |

elasticsearch和kibana已经安装好了x-pack插件

## 2 Build
公司环境虚拟机里面的docker默认配置不能上网，可以使用host网络模式 --network=host 编译的时候让container与虚拟机公用同一个网络环境  
或者自建一个docker 网络， 下面使用自建名为hadoop的网络，之后的集群通信也基于该网络
```bash
docker network create --driver=bridge hadoop
docker build --network=host -t centos6-elk-rpm .
```

## 3 启动容器
```bash
# 启动容器脚本使用说明
$ ./start-cluster-containers.sh 
[INFO] Parse all the arguments....
  usage: ./start-cluster-containers.sh -m|-mode=[run|start|stop] -i|-image=[image name] -h|--hlep
    -mode   -m   run mode  
                 [run]: remove old containers and create new containers
                 [start]: if container exist, then start again; if not exists, then run a new container
                 [stop]: stop exists containers
    -image  -i   image name, default name is "centos6-elk-rpm" 
```

```bash
# 如果没有修改上面编译时候的镜像名称
./start-cluster-containers.sh -m=run
```


## 4 进入容器，启动服务
默认正常启动之后会attach到es-master
```bash
# root @ es-master in ~ [3:10:02] C:130
$ ./conf-elk/daemons-es.sh               
  usage: ./conf-elk/daemons-es.sh --init/--start/--stop/--restart
    init      initialize new cluster environment
    start     start an existing cluster
    stop      stop cluster
    restart   restart cluster
```

首次启动需要带上--init初始化参数
初始化的时候会配置相关配置文件
```bash
$ ./conf-elk/daemons-es.sh --init --start
```



