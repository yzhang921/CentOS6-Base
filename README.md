# Ctrip内部环境用命令行搭建CDH运行环境试验
- 该分支一master分支为基础，运行之前需要先构建好master分支的镜像，master分支默认构建镜像名称为centos6-base，可以自行修改
- 
- 配置了Ctrip内部CDH5.7.1，CentOS Repository
- 安装CDH


## Build
```bash
git clone git@git.dev.sh.ctripcorp.com:zyong/CentOS6-Base.git CentOS6-Base-Ctrip
git checkout ctrip-cdh-test
docker build --network=host -t centos6-cdh-cmd .
```
## 运行前提
- 容器互联网络已经建立，建立命令如下
    - docker network create --driver=bridge hadoop

# 运行实例

```bash
docker run -d --name=cmd-master --hostname=cmd-master -it --network=hadoop --privileged=true centos6-cdh-cmd
docker run -d --name=cmd-slave1 --hostname=cmd-slave1 -it --network=hadoop --privileged=true centos6-cdh-cmd
```

