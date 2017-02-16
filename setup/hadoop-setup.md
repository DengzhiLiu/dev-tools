安装基本应用
yum install svn   ncurses-devel   gcc* lzo-devel zlib-devel autoconf    automake    libtool    cmake    openssl –devel
安装jdk环境
下载我就不说了,建议使用1.7版本的jdk,否则会有语法之类的报错,苦不堪言啊!

##解压
tar xf jdk-7u79-linux-x64.tar.gz -C /usr/local
cd /usr/local/

##创建软连接
ln -sv /usr/local/jdk1.7.0_79 /usr/local/jdk  ##建议保留原来的包名,做个软连接,这样一眼就可以看出现在用的jdk是什么本(后面的软件都一样)

##编辑/etc/profile文件配置java环境变量
JAVA_HOME=/usr/local/jdk
PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:
CLASSPATH=$CLASSPATH:.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

##重新加载一下/etc/profile文件
source /etc/profile

##验证java环境安装,出现下面的就说明安装正常
[root@master local]# java -version
java version "1.7.0_79"
Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)

安装protobuf-2.5.0.tar.gz (请确保只能是2.5.0的版本,刚从坑里爬起来~)
下载链接：http://pan.baidu.com/s/1dDgWe6P 密码：xgiu  (网上找的,不一定永久有效)
##解压
tar xf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0
./configure && make && make install
##验证安装是否成功
protoc --version 
[root@master src]# protoc --version
libprotoc 2.5.0

安装maven
wget http://apache.opencas.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xf apache-maven-3.3.9-bin.tar.gz -C /usr/local
cd /usr/local

##创建软连接
ln -sv apache-maven-3.3.9 maven

##编辑/etc/profile文件配置maven环境变量
export MAVEN_HOME=/usr/local/maven
export PATH=$PATH:$MAVEN_HOME:/bin

##重新加载一下/etc/profile文件
source /etc/profile

##验证java环境安装,出现下面的就说明安装正常
[root@master local]# mvn -version
Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-11T00:41:47+08:00)
Maven home: /usr/local/maven
Java version: 1.7.0_79, vendor: Oracle Corporation
Java home: /usr/local/jdk1.7.0_79/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "linux", version: "2.6.32-573.el6.x86_64", arch: "amd64", family: "unix"

安装ant
##下载
wget http://mirrors.cnnic.cn/apache//ant/binaries/apache-ant-1.9.6-bin.tar.gz
          
           ##解压
          tar xf apache-ant-1.9.6-bin.tar.gz -C /usr/local
          cd /usr/local
         
          ##创建软连接
          ln -sv apache-ant-1.9.6  ant
   
          ##编辑/etc/profile文件配置ant环境变量
         export ANT_HOME=/usr/local/ant
         export PATH=$PATH:$ANT_HOME:/bin       
       
         ##重新加载一下/etc/profile文件
         source /etc/profile 
 
        ##验证ant环境安装,出现下面的就说明安装正常
        [root@master local]# ant -version
        Apache Ant(TM) version 1.9.6 compiled on June 29 2015
 6. 编译安装hadoop
         ## 下载
         wget http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.6.4/hadoop-2.6.4-src.tar.gz
        ## 解压
        tar xf hadoop-2.6.4-src.tar.gz
        cd hadoop-2.6.4-src
        ##编译
        mvn package -Pdist,native -DskipTests -Dtar 
        
     出现BUILD SUCCESS,那就恭喜你已经编译成功了
     编译过程中也会遇到各种报错,如果遇到报错,可以使用 mvn package -Pdist,native -DskipTests -Dtar -e -X 打印出debug信息,方便排查问题
     我这边如果遇到过的问题基本有下面几个protobuf 的版本不符合,指定需要2.5.0 ,我用了最新版的,还有我用虚拟机编译的,报了一次内存不够的情况,最开始我用jdk是1.8的后来报了类似语法错误,我就果断换成1.7,就好了
 

 
现在来配置hadoop,让它能够跑起来,配置一些hdfs的ha模式
配置主机名和hosts
127.0.0.1 master
127.0.0.2 slave1
127.0.0.3 slave2
2. 创建ssh 密钥,试3台都互相免密钥登录,过程略,创建hdfs用户
         useradd hdfs
3. hadoop主要涉及到的配置文件有5个:hadoop-env.sh core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml
      其中: 
hadoop-env.sh:
export JAVA_HOME=/usr/local/jdk
 
core-site.xml:
<configuration>
<property>
  <name>hadoop.tmp.dir</name>
  <value>/app/hadoop/tmp</value>
  <description>A base for other temporary directories.</description>
</property>
<property>
  <name>fs.defaultFS</name>
  <value>hdfs://mycluster</value>
  <description>The name of the default file system.  A URI whose
  scheme and authority determine the FileSystem implementation.  The
  uri's scheme determines the config property (fs.SCHEME.impl) naming
  the FileSystem implementation class.  The uri's authority is used to
  determine the host, port, etc. for a filesystem.</description>
</property>
<property>
  <name>hadoop.proxyuser.mapred.groups</name>
  <value>*</value>
  <description>Allows the mapreduser to move files belonging to users in these groups.</description>
</property>
<property>
  <name>hadoop.proxyuser.mapred.hosts</name>
  <value>*</value>
  <description>Allows the mapreduser to move files belonging on these hosts.</description>
</property>
<property>
  <name>hadoop.native.lib</name>
  <value>true</value>
  <description>Should native hadoop libraries, if present, be used.</description>
</property>
<property>
  <name>dfs.replication</name>
  <value>1</value>
</property>
<property>
  <name>mapred.child.java.opts</name>
  <value>-Xmx256m</value>
</property>
<property>
<name>io.compression.codecs</name>
<value>org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.BZip2Codec,com.hadoop.compression.lzo.LzoCodec,com.hadoop.compression.lzo.LzopCodec
</value>
</property>
<property>
<name>io.compression.codec.lzo.class</name>
<value>com.hadoop.compression.lzo.LzoCodec</value>
</property>
</configuration>
 
 
hdfs-site.xml:
<configuration>
<property>
  <name>dfs.webhdfs.enabled</name>
  <value>true</value>
</property>
<property>
  <name>dfs.webhdfs.user.provider.user.pattern</name>
  <value>^[A-Za-z0-9_][A-Za-z0-9._-]*[$]?$</value>
</property>
<property>
  <name>dfs.nameservices</name>
  <value>mycluster</value>
</property>
<property>
  <name>dfs.ha.namenodes.mycluster</name>
  <value>nn1,nn2</value>
</property>
<property>
  <name>dfs.namenode.rpc-address.mycluster.nn1</name>
  <value>master:8020</value>
</property>
<property>
  <name>dfs.namenode.rpc-address.mycluster.nn2</name>
  <value>slave1:8020</value>
</property>
<property>
  <name>dfs.namenode.http-address.mycluster.nn1</name>
  <value>master:50070</value>
</property>
<property>
  <name>dfs.namenode.http-address.mycluster.nn2</name>
  <value>slave1:50070</value>
</property>
<property>
  <name>dfs.namenode.shared.edits.dir</name>
  <value>qjournal://master:8485;slave1:8485;slave2:8485/mycluster</value>
</property>
<property>
  <name>dfs.journalnode.edits.dir</name>
  <value>/data/1/dfs/jn</value>
</property>
<property>
  <name>dfs.client.failover.proxy.provider.mycluster</name>
  <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
</property>
<property>
  <name>dfs.ha.fencing.methods</name>
  <value>sshfence</value>
</property>
<property>
  <name>dfs.ha.fencing.ssh.private-key-files</name>
  <value>/home/hduser/.ssh/id_rsa</value>
</property>
<property>
  <name>dfs.ha.fencing.methods</name>
  <value>shell(/home/scripts/hdfs.sh)</value>
</property>
<property>
  <name>dfs.ha.automatic-failover.enabled</name>
  <value>true</value>
</property>
<property>
  <name>ha.zookeeper.quorum</name>
  <value>master:2181,slave1:2181,slave2:2181</value>
</property>
<property>
  <name>dfs.replication</name>
  <value>1</value>
  <description>Default block replication.
  The actual number of replications can be specified when the file is created.
  The default is used if replication is not specified in create time.
  </description>
</property>
<property>
  <name>io.compression.codecs</name>
  <value>org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.GzipCodec,
org.apache.hadoop.io.compress.BZip2Codec,com.hadoop.compression.lzo.LzoCodec,
com.hadoop.compression.lzo.LzopCodec,org.apache.hadoop.io.compress.SnappyCodec</value>
</property>
</configuration>
 
yarn-site.xml:
<configuration>
<!-- Site specific YARN configuration properties -->
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>master</value>
  </property>
 
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>file:///data/1/yarn/local,file:///data/2/yarn/local,file:///data/3/yarn/local</value>
  </property>
  <property>
    <name>yarn.nodemanager.log-dirs</name>
    <value>file:///data/1/yarn/logs,file:///data/2/yarn/logs,file:///data/3/yarn/logs</value>
  </property>
  <property>
    <name>yarn.log.aggregation-enable</name>
    <value>true</value>
  </property>
  <property>
    <description>Where to aggregate logs</description>
    <name>yarn.nodemanager.remote-app-log-dir</name>
    <value>hdfs://mycluster:8020/var/log/hadoop-yarn/apps</value>
  </property>
</configuration>
mkdir -p /data/{1,2,3}/yarn/local /data/{1,2,3}/yarn/logs
chown -R hdfs:hdfs /data/{1,2,3}/yarn/local /data/{1,2,3}/yarn/logs
chmod 700 /data/{1,2,3}/yarn/local /data/{1,2,3}/yarn/logs
 
mapred-site.xml:
<configuration>
<property>
 <name>mapreduce.framework.name</name>
 <value>yarn</value>
</property>
<property>
 <name>mapreduce.jobhistory.address</name>
 <value>master:10020</value>
</property>
<property>
 <name>mapreduce.jobhistory.webapp.address</name>
 <value>master:19888</value>
</property>
<property>
 <name>yarn.app.mapreduce.am.staging-dir</name>
 <value>/user</value>
</property>
<property>
 <name>mapreduce.jobhistory.intermediate-done-dir</name>
 <value>/user/history</value>
</property>
<property>
 <name>mapreduce.jobhistory.done-dir</name>
 <value>/user/history/done</value>
</property>
</configuration>
 
hadoop fs -mkdir /user
hadoop fs -mkdir /user/history
hadoop fs -mkdir /user/history/done
hadoop fs -chown -R hdfs.hdfs /user/
 
