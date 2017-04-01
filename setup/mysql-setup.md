```
2.3.安装步骤
2.3.1. 准备工作
卸载原有的mysql server
rpm –qa|grep mysql
rpm –e –nodeps mysql ( 如果上面命令出现mysql的安装包)

新建mysql用户和用户组
useradd  mysql
groupadd mysql

新建mysql所需要的目录
mkdir  /data/mysql/data -p
mkdir  /data/mysql/arch
mkdir  /data/mysql/logs
chown –R  mysql.  /data/mysql

安装依赖包
yum –y install gcc gcc-c++ ncurses-devel perl cmake bison bison-devel gbd  readline-devel

下载源码包并放在/srv目录下
下载地址：http://dev.mysql.com/downloads/mysql/

2.3.2.安装过程
解压源码包
cd  /srv
tar xf mysql-5.6.26.tar
cd  mysql-5.6.26

camke编译（从mysql5.5开始使用camke编译）
cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data/mysql/data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DMYSQL_UNIX_ADDR=/data/mysql/tmp/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci

make/make –j(并发执行)
make install

注：如果重新编译rm –rf CMakeCache.txt
                make clean

初始化数据库
cd /usr/local/mysql/scripts
chmod 755 mysql_install_db
mysql_install_db --user=mysql --basedir=/usr/local/mysql/   --datadir=/data/mysql/data --defaults-file=/etc/my.cnf

生成mysql配置文件
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

配置启动脚本并加入PATH路径
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
vim /etc/profile添加以下内容
PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH
export PATH
source /etc/profile

启动mysql并添加开机自启动
service mysqld start
chkconfig mysqld on

设置root密码并删除空弱密码(可以不做)
mysqladmin -u root password 'new-password'
mysql -uroot -p'new-password' –h 127.0.0.1
mysql>use mysql; //选择系统数据库mysql
mysql>select Host,User,Password from user; //查看所有用户
mysql>delete from user where password="";
mysql>flush privileges;
mysql>select Host,User,Password from user; //确认密码为空的用户是否已全部删除
mysql>exit;
mysql> grant all privileges on  *.*  to 'root'@'%' identified by '密码'；
mysql>flush privileges;


2.4.配置文件优化详解
以下为线上数据库my.cnf的配置
[client]
port            = 3306
socket          = /data/mysql/mysql.sock

[mysql]
no_auto_rehash
###prompt = "\\R:\\m:\\s \\d> "
prompt = [\\u@\\h][\\d]>\\_     ### 操作时提示库,表
pager = "more"

[mysqld]
port            = 3306
user            = mysql
socket          = /data/mysql/mysql.sock
basedir    = /usr/local/mysql    #####软件目录
datadir    = /data/mysql/data   #####数据目录

character_set_server=utf8mb4
collation_server=utf8mb4_unicode_ci    #####数据库字符集

sysdate-is-now
skip-name-resolve               #####跳过域名反解析

open_files_limit = 60000         #####打开文件数
table_open_cache = 4096

max_connections = 3500           #####最大连接数
max_connect_errors  = 100000        #####最大错误连接数
log-bin-trust-function-creators=1    #####打开自定义函数

####$连接超时
wait_timeout = 86400
interactive_timeout = 86400
pid-file=/data/mysql/data/mysql.pid

####session级别参数
sort_buffer_size = 4M
read_buffer_size = 4M
read_rnd_buffer_size = 8M
join_buffer_size=8M
tmp_table_size=512M
max_heap_table_size = 512M
max_allowed_packet = 128M
myisam_sort_buffer_size=128M
tmpdir=/data/mysql/mysql_tmp

key_buffer_size = 1G           #####myisam表 buffer size

query_cache_size   = 0          #####关闭查询缓存

####优化器，关闭index merger
optimizer_switch=index_merge=off,index_merge_union=off,index_merge_sort_union=off,index_merge_intersection=off,engine_con
dition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materi
alization=on,semijoin=on,loosescan=on,firstmatch=on,subquery_materialization_cost_based=on,use_index_extensions=on

# Try number of CPU's*2 for thread_concurrency
thread_concurrency = 8
thread_cache_size = 6

#lower_case_table_names=1        ####表明区分大小写

# ====================== Logs Settings ================================
log-warnings
skip-log-warnings
log-error                       = /data/mysql/logs/error.log

#general-log                     = 1
#general_log_file                = /data/mysql/logs/general.log

#slow-query-log
slow_query_log=1
slow_query_log_file             = /data/mysql/logs/slowquery.log
long_query_time                 = 1
#log-queries-not-using-indexes


log-bin=/data/mysql/arch/mysql-bin
sync_binlog = 1
expire_logs_days   = 10
binlog_format = ROW
binlog_cache_size  = 2M
max_binlog_size    = 1024M



# ===================== Replication settings =========================
server-id  = 155
#skip-slave-start
#slave-skip-errors=1032,1062
#replicate-do-db              =
#replicate-ignore-db          =
#replicate-ignore-table       =

relay-log          = /data/mysql/arch/mysql-relay-bin
relay-log-index    = /data/mysql/arch/mysql-relay-bin.index
relay-log-purge     = 1
#log-slave-updates

# ====================== INNODB Specific Options ======================
innodb_data_home_dir = /data/mysql/data                  ####innodb数据目录
innodb_data_file_path = ibdata1:1024M:autoextend          ####ibdata大小
innodb_buffer_pool_size =24G                           ####innodb buffer大小
innodb_log_buffer_size = 64M                            ####innodb log buffer大小
innodb_log_group_home_dir = /data/mysql/arch             ####innodb log 目录
innodb_log_files_in_group = 3                            ####innodb log组成员数量
innodb_log_file_size = 512M                             ####innodb log file 大小
innodb_fast_shutdown    = 1
innodb_force_recovery   = 0
innodb_file_per_table = 1                                ####innodb 独立表空间
innodb_lock_wait_timeout = 100
innodb_thread_concurrency = 24
innodb_flush_log_at_trx_commit = 1
innodb_flush_method  = O_DIRECT
innodb_locks_unsafe_for_binlog=1
innodb_read_io_threads=4
innodb-write-io-threads=4
innodb-io-capacity=600                                  ####ssd盘设置3000
innodb_purge_threads=1
innodb_autoinc_lock_mode=2
innodb_buffer_pool_instances=2
innodb_max_dirty_pages_pct = 75                          ####innodb脏页刷新率
transaction-isolation = READ-COMMITTED                   ####数据库隔离级别

启动mysql: mysqld_safe  --defaults-file=/etc/my.cnf --user=mysql  &
连接mysql客户端: mysql -uroot -p'pass' -hlocalhost


```



