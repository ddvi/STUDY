###### 安装注意事项 ######################################
###### 自动安装数据库脚本 ################################
###### 请将此脚本和数据库的tar.gz的压缩包放到同一目录 ######
###### root密码默认123456 ################################
###### 数据库目录/data/mysql #############################
###### 数据目录/data/mysql/data ##########################
###### 慢日志目录/data/slowlog ###########################
###### 端口号默认3306其余参数按需自行修改 #################
###### 用Navicat连接时账号为root,密码为123456 #############
 



#!/bin/bash
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi
clear
echo "========================================================================="
echo "A tool to auto-compile & install MySQL  on Redhat/CentOS Linux "
echo "========================================================================="
cur_dir=$(pwd)
#set mysql root password
echo "==========================="
mysqlrootpwd="123456"
echo -e "请输入你要为数据库设置的root用户的密码:"
read -p "(默认密码 password: 123456):" mysqlrootpwd
if [ "$mysqlrootpwd" = "" ]; then
    mysqlrootpwd="123456"
fi
echo "==========================="
echo "MySQL root password:$mysqlrootpwd"
echo "===========================" 
#which MySQL Version do you want to install?
echo "==========================="
isinstallmysql56="n"
echo "继续安装数据库，请输入y并回车"
read -p "(Please input y , n):" isinstallmysql56
case "$isinstallmysql56" in
y|Y|Yes|YES|yes|yES|yEs|YeS|yeS)
echo "You will install MySQL "
isinstallmysql56="y"
;;
*)
echo "输入错误，请执行脚本重新安装MySQL "
isinstallmysql56="n"
exit
esac
get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
#dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
echo "Press any key to start...or Press Ctrl+c to cancel"
char=`get_char`
# Initialize  the installation related content.
function InitInstall()
{
cat /etc/issue
uname -a
MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
echo -e "\n Memory is: ${MemTotal} MB "
#Set timezone
#rm -rf /etc/localtime
#ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#Delete Old mariadb program
#MARIA=`rpm -qa|grep mariadb`
rpm -qa |grep mysql|xargs -n 1 rpm -e  --nodeps && echo 老版本mysql未安装，无需卸载！
rpm -qa |grep mariadb|xargs -n 1 rpm -e  --nodeps && echo mariadb 卸载完成！
#yum remove $MARIA
#Disable SeLinux
if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi
setenforce 0
}
 
#Installation of depend on and optimization options.
function InstallDependsAndOpt()
{
cd $cur_dir
cat >>/etc/security/limits.conf<<EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
echo "fs.file-max=65535" >> /etc/sysctl.conf
}
#Install MySQL
function InstallMySQL56()
{
echo "============================Install MySQL =================================="
cd $cur_dir
#Backup old my.cnf
#rm -f /etc/my.cnf
if [ -s /etc/my.cnf ]; then
    mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d%H%M%S`.bak
fi
echo "============================MySQL  installing…………========================="
#mysql directory configuration
mkdir -p /data/

tar zxvf mysql-*.tar.gz -C /data/  && echo 数据库解压完成！
sleep 1
cd /data/
ln -sv mysql-*x86_64 /data/mysql
groupadd mysql -g 512
useradd -u 512 -g mysql -s /sbin/nologin -d /home/mysql mysql
touch /data/mysql/error.log
mkdir -p /data/slowlog
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /data/slowlog
#edit /etc/my.cnf
SERVERID=`ifconfig eno16777736 | grep "inet " | awk '{ print $2}'| awk -F. '{ print $3$4}'`
cat >>/etc/my.cnf<<EOF
[client]
port=3306
socket=/tmp/mysql.sock
default-character-set=utf8
 
[mysql]
no-auto-rehash
default-character-set=utf8
 
[mysqld]
port=3306
character-set-server=utf8
socket=/tmp/mysql.sock
basedir=/data/mysql
datadir=/data/mysql/data
explicit_defaults_for_timestamp=true
back_log=103
max_connections=3000
max_connect_errors=100000
table_open_cache=512
external-locking=FALSE
max_allowed_packet=32M
sort_buffer_size=2M
join_buffer_size=2M
thread_cache_size=51
query_cache_size=32M
#query_cache_limit=4M
transaction_isolation=REPEATABLE-READ
tmp_table_size=96M
max_heap_table_size=96M
 
###***slowqueryparameters
long_query_time=1
slow_query_log = 1
slow_query_log_file=/data/slowlog/slow.log
 
###***binlogparameters
log-bin=mysql-bin
binlog_cache_size=4M
max_binlog_cache_size=4096M
max_binlog_size=1024M
binlog_format=MIXED
expire_logs_days=7
 
###***relay-logparameters
#relay-log=/data/3307/relay-bin
#relay-log-info-file=/data/3307/relay-log.info
#master-info-repository=table
#relay-log-info-repository=table
#relay-log-recovery=1
 
#***MyISAMparameters
key_buffer_size=16M
read_buffer_size=1M
read_rnd_buffer_size=16M
bulk_insert_buffer_size=1M
 
#skip-name-resolve
 
###***master-slavereplicationparameters
server-id=$SERVERID
#slave-skip-errors=all
 
#***Innodbstorageengineparameters
innodb_buffer_pool_size=512M
innodb_data_file_path=ibdata1:10M:autoextend
#innodb_file_io_threads=8
innodb_thread_concurrency=16
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size=16M
innodb_log_file_size=512M
innodb_log_files_in_group=2
innodb_max_dirty_pages_pct=75
innodb_lock_wait_timeout=50
innodb_file_per_table=on
 
[mysqldump]
quick
max_allowed_packet=32M
 
[myisamchk]
key_buffer=16M
sort_buffer_size=16M
read_buffer=8M
write_buffer=8M
 
[mysqld_safe]
open-files-limit=8192
log-error=/data/mysql/error.log
pid-file=/data/mysql/mysqld.pid

EOF

/data/mysql/scripts/mysql_install_db --user=mysql --datadir=/data/mysql/data --basedir=/data/mysql
 
cp /data/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 700 /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 2345 mysqld on
 
cat >> /etc/ld.so.conf.d/mysql-x86_64.conf<<EOF
/usr/local/mysql/lib
EOF
ldconfig
 
if [ -d "/proc/vz" ];then
ulimit -s unlimited
fi
 
/etc/init.d/mysqld start


/data/mysql/bin/mysqladmin -u root password $mysqlrootpwd
 
cat > /tmp/mysql_sec_script<<EOF
use mysql;
delete from mysql.user where user!='root' or host!='localhost';
grant all privileges on *.* to 'root'@'%' identified by '123456';
drop database test;
flush privileges;
EOF
 
/data/mysql/bin/mysql -u root -p$mysqlrootpwd -h localhost < /tmp/mysql_sec_script
 
rm -f /tmp/mysql_sec_script
 
 
#/etc/init.d/mysqld restart
 
echo 'PATH=/data/mysql/bin/:$PATH' >>/etc/profile

source /etc/profile
 
 
echo "============================MySQL  install completed========================="
}
 
 
 
function CheckInstall()
{
echo "===================================== Check install ==================================="
clear
ismysql=""
echo "Checking..."
 
if [ -s /data/mysql/bin/mysql ] && [ -s /data/mysql/bin/mysqld_safe ] && [ -s /etc/my.cnf ]; then
  echo "MySQL: OK"
  ismysql="ok"
  else
  echo "Error: /data/mysql not found!!!MySQL install failed."
fi
 
if [ "$ismysql" = "ok" ]; then
echo "Install MySQL  completed! enjoy it."
echo "========================================================================="
netstat -ntl
else
echo "Sorry,Failed to install MySQL!"
echo "You can tail /root/mysql-install.log from your server."
fi
}
 
#安装日志路径
InitInstall 2>&1 | tee /root/mysql-install.log
InstallDependsAndOpt 2>&1 | tee -a /root/mysql-install.log
InstallMySQL56 > /dev/null
CheckInstall 2>&1 | tee -a /root/mysql-install.log
#创建软连接
ln -sv /data/mysql/bin/mysql /usr/bin
echo 输入 mysql -uroot -p 即可进入数据库，测试是否安装完成！


#删除安装完成后的安装包
#find /root -type f -name 'mysql*' -exec rm -rf {} \;
