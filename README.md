# Ctrip内部环境用命令行搭建CDH运行环境试验
- 该分支一master分支为基础，**运行之前需要先构建好master分支的镜像**，master分支默认构建镜像名称为centos6-base，可以自行修改
- 配置了Ctrip内部CDH5.7.1，CentOS Repository
- 安装CDH

# Build
```bash
git clone git@git.dev.sh.ctripcorp.com:zyong/CentOS6-Base.git CentOS6-Base-Ctrip
git checkout ctrip-cdh-test
docker build --network=host -t centos6-cdh-cmd .
```
# 运行前提
- 容器互联网络已经建立，建立命令如下
    - docker network create --driver=bridge hadoop

# 运行实例
在宿主机上面运行启动容器集群脚本
```bash
chmod 755 start-cluster.sh
# Change parameter of image name before start cluster containers
./start-cluster.sh [your-image]
# For example， I build with name centos6-cdh-cmd then command like below：
./start-cluster.sh centos6-cdh-cmd
```

# 进入集群Master启动CDH
```bash
docker attach cmd-master
cd cdh-conf
# 启动 NameNode，DataNode， ResourceManager，NodeManager
./start-daemons.sh
```
启动之后在可以宿主机上面查看集群状态
http://localhost:50070 <HDFS管理界面>
http://localhost:8088 <YARN监控界面>

# 运行测试任务
```bash
# run pi
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 10 100
# run wordcount
hdfs dfs -rm -r -f /tmp/output
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /root/cdh-conf /tmp/output
```