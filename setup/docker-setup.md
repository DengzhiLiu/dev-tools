一、查看机器是否有安装docker
       docker -v
二、安装docker
      若本机没有安装docker，则通过下面的命令来安装：
       sudo yum  install docker-io
三、启动docker服务
       sudo service docker start
       If you're using CentOS 7, and you've installed Docker via yum, don't forget to run:
      $ sudo systemctl start docker
      $ sudo systemctl enable docker
四、查看本地的docker镜像：
       使用 docker images 命令列出可用来创建 Docker 容器的本地镜像。
五、从docker仓库下载镜像（例子）
        docker pull ubuntu:14.04
       docker操作不需要加 sudo
       注意：用下面的命令装载已有的镜像包，如果用 docker images查看出来已经有的话就不用装载了
         docker load </usr/local/src/linux.tar
       或者：  cat /usr/local/src/linux.tar  |docker import - centos:latest
六、根据docker镜像创建自己定制的docker container
        docker run -d -i  -h="banyandb" --name="banyandb_server" --cpuset-cpus=5-6 -p 10600:10600 -p 10601:10601 -p 10602:10602  -p 10603:10603 -v /data:/data centos:latest /bin/bash
        参数：
        -d:  以后台的方式运行
        -p: 指定IP映射
       -v : 指定data目录
     注意： 自己配置时要到名字和主机中的banyandb替换掉
七、启动SSH
       docker exec 8429f07418c8 /etc/init.d/sshd start
       8429f07418c8 为container ID，可以用 docker ps -a 命令查看
八、查看IP
       docker exec 8429f07418c8 ifconfig
       8429f07418c8 为container ID
       要登进自己的docker容器的话先要启动SSH服务，然后通过ssh  ip登进去
九、动态增加端口
     这个命令可以在后面需要增加映射端口时使用
     iptables -t nat -A PREROUTING -p tcp -m tcp --dport 10700 -j DNAT --to-destination 172.17.0.1:10700
十、停止docker
        查看container ID号：
       docker ps -a -q
       停止container:
       docker stop $(container ID)
十一、删除docker镜像
        docker rmi $(image id)
        image可以由 docker image命令查看到
十二、 将自己的docker container保存成一个新的docker镜像
       docker commit $(Container ID)  centsos:new
      在docker容器里面更新包之后可以把容器更新成一个新的镜像
十三　以命令交互的方式运行docker
　　　　　　　　docker exec -ti $(container name) /bin/bash


