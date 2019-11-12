# nginx
[toc]
## 简述
nginx是一个开源的，高性能的，可靠的http中间件，代理服务

### IO复用内核模式种类
类型一、select、poll模型
类型二、epoll模型
sellect-->poll-->epoll

### epoll
优势一、解决SELECT模型对于文件句柄FD打开限制

优势二、采用callback函数回调机制优化模型效率

### cpu亲和
是一种把CPU核心和nginx工作进程绑定方式，吧每个woker进程固定在一个cpu上执行，减少cpu切换的cache miss，获得更好的性能

## 配置信息以及参数
### 安装目录讲解
|路径|类型|作用|
|:--:|:--:|:--:|
|/etc/logrotate.d/nginx|配置文件|nginx日志轮转，用于logrotate服务的日志切割|
|/etc/nginx<br>/etc/nginx/nginx.conf<br>/etc/nginx/conf.d<br>/etc/nginx/conf.d/default.conf|目录、配置文件|nginx主配置文件|
|/etc/nginx/fastcgi_params<br>/etc/nginx/uwsgi_params<br>/etc/nginx/scgi_params|配置文件|cgi配置相关，fastcgi配置|
|/etc/nginx/mine.types|配置文件|设置http协议的Content-Type与扩展名对应关系|
|/usr/lib/systemd/system/nginx-debug.service<br>/usr/lib/systemd/system/nginx.service<br>/etc/sysconfig/nginx<br>/etc/sysconfig/nginx-debug|配置文件|用于配置出系统守护进程管理器的管理方式|
|/usr/lib64/nginx/modules<br>/etc/nginx/modules|目录|Nginx模块目录|
|/usr/share/doc/nginx-版本号<br>/usr/share/doc/nginx-版本号/COPYRIGHT<br>/usr/share/man8/nginx.8.gz|文件、目录|nginx手册和帮助文件|
|/var/cache/nginx|目录|nginx缓存目录|

### 安装编译参数
|编译选项|作用|
|:--:|:--:|
|--prefix=/etc/nginx<br>--sbin-path=/usr/sbin/nginx<br>--modules-path=/usr/lib64/nginx/modules<br>--conf-path=/etc/nginx/nginx.conf<br>--error-log-path=/var/log/nginx/error.log<br>--http-log-path=/var/log/nginx/access.log<br>--pid-path=/var/run/nginx.pid<br>--lock-path=/var/run/nginx.lock|安装目录或路径|
|--http-client-body-temp-path=/var/cache/nginx/client_temp<br>--http-proxy-temp-path=/var/cache/nginx/proxy_temp<br>--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp<br>--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp<br>--http-scgi-temp-path=/var/cache/nginx/scgi_temp|执行对应模块时，nginx所保留的临时性文件|
|--user=nginx<br>--group=nginx|设定nginx进程启动的用户和组用户|
|--with-cc-opt=parameters|设置额外的参数将被添加到CFLAGS变量|
|--with-ld-opt=parameters|设置附加的参数，链接系统库|

### 默认配置
|配置项|含义|
|:--:|:--:|
|usr|设置nginx服务的系统使用用户|
|work_process|工作进程数|
|error_log|nginx错误日志|
|pid|nginx服务启动时pid|

### event模块
|配置项|含义|
|:--:|:--:|
|work_connections|每个进程允许的最大连接数|
|use|所使用的内核模型|

### http模块
```
http {
    ... ...
    server {
        listen 80;
        server_name localhost;

        location / {
            root  /usr/share/nginx/html;
            index  index.html index.htm
        }
        error_page  500 502 503 504 /50x.html;
        location = /50x.html {
            root  /usr/share/nginx/html
            }
    server {
        ... ...
    }
}
```

### http请求
request-包括请求行、请求头部、请求数据
response-包括状态行、消息报头、响应正文

curl -v http://www.immoc.com >/dev/null


## 虚拟主机实现方式
定义： 在同一nginx上运行多套单独服务，这些服务是相互独立的

### 配置方式
1. 基于主机多ip配置方式
2. 基于端口的配置方式
3. 基于多个host名称方式

### 基于主机多ip方式
1. 多网卡多ip方式
2. 单网卡多ip方式
网卡添加ip命令：
ip a add + ip/掩码 dev eth*

```
#配置文件1
server {
    listen       80;
    server_name  192.168.0.5;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /opt/nginx/app/code1;
        index  index.html index.htm;
    }
#配置文件2
server {
    listen       80;
    server_name  192.168.0.6;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /opt/nginx/app/code2;
        index  index.html index.htm;
    }

#指定配置文件启动
nginx -c /etc/nginx/nginx.conf
#停止nginx
nginx -s stop /etc/nginx/nginx.conf
```

### 基于多端口
参考上述配置进行修改即可
检查配置文件语法是否正确
nginx -tc /etc/nginx/nginx.conf 

### 基于host域名配置
修改静态解析文件
参考上述文件修改即可


## 日志类型
### error.log access.log
log_format
Syntax: log_format name [escape=default|json] string ...;        #配置语法
Default:log_format combined "...";                               #默认配置
Context:http                                                     #logformat只能配置在http模块下

```
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    #定义日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    #以main的格式要求记录access日志
```
### nginx变量
http请求变量-arg_PARAMETER、http_HEADER（request）、sent_http_HEADER（response）
内置变量-nginx内置的
自定义变量-自己定义的

#### http请求变量
如果想日志记录请求头中的User-Agent信息，可按照如下步骤进行处理
```
[root@manman nginx]# curl -v http://10.9.19.59 > /dev/null
* About to connect() to 10.9.19.59 port 80 (#0)
*   Trying 10.9.19.59...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to 10.9.19.59 (10.9.19.59) port 80 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.29.0
> Host: 10.9.19.59
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx/1.17.5
< Date: Tue, 05 Nov 2019 13:57:12 GMT
< Content-Type: text/html
< Content-Length: 616
< Last-Modified: Tue, 05 Nov 2019 09:38:42 GMT
< Connection: keep-alive
< ETag: "5dc14322-268"
< Accept-Ranges: bytes
< 
{ [data not shown]
100   616  100   616    0     0   480k      0 --:--:-- --:--:-- --:--:--  601k
* Connection #0 to host 10.9.19.59 left intact
```
1. 修改/etc/nginx/nginx.conf
2. 修改log_format参数
3. 增加\$http_user_agent参数
    参数前加上\$http_
    大写需要修改为小写
    -需要修改为_，
```
    log_format  main  '$http_user_agent $remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
```
4. 检查配置文件语法格式
nginx -t -c /etc/nginx/nginx.conf
5. 重新加载配置文件
nginx -s reload -c /etc/nginx/nginx.conf
6.发起一次请求并查看access.log日志,发现开头已经变化
```
5.189.170.96 - - [05/Nov/2019:22:12:50 +0800] "GET / HTTP/1.0" 200 616 "-" "masscan/1.0 (https://github.com/robertdavidgraham/masscan)" "-"
curl/7.29.0 127.0.0.1 - - [05/Nov/2019:22:15:30 +0800] "GET / HTTP/1.1" 200 616 "-" "curl/7.29.0" "-"
```
#### nginx内置变量
http://nginx.org/en/docs/http/ngx_http_core_module.html#var_status

#### 自定义变量   后续讲解 lua章节


## 模块
nginx官方模块
第三方模块

### nginx官方模块

#### _sub_status
|编译选项|作用|
|:--:|:--:|
|--with-http_stub_status_module|nginx当前处理连接状态|

##### 配置语法
Syntax:stub_status                 
Ddfault:——                         \#默认无配置
Context:server,location            \#在server,location下配置

##### 配置步骤
1. nginx -V确认包含此模块
2. 打开XXXX.conf配置文件，在server下添加location参数以及stub_status配置
```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;
#添加如下配置（一定要加分号）
   location /mystatus {
        stub_status;
    }

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;
    
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html; 
    }
```
3. 检查配置文件语法格式
nginx -t -c /etc/nginx/nginx.conf
4. 重新加载配置文件
nginx -s reload -c /etc/nginx/nginx.conf
5. 访问如下地址
http://106.75.97.163/mystatus

显示如下参数
```
Active connections: 1 
server accepts handled requests
 58 58 81 
Reading: 0 Writing: 1 Waiting: 0 
```
Active connections: 当前nginx正在处理的活动连接数.
Server accepts  handled r equests : nginx总共处理了58个连接,成功创建58握手(证明中间没有失败的),总共处理了81 个请求
Reading: nginx读取到客户端的Header信息数.
Writing: nginx返回给客户端的Header信息数.
Waiting: 开启keep-alive的情况下,这个值等于 active – (reading + writing),意思就是nginx已经处理完成,正在等候下一次请求指令的驻留连接。
所以,在访问效率高,请求很快被处理完毕的情况下,Waiting数比较多是正常的.如果reading +writing数较多,则说明并发访问量非常大,正在处理过程中。

#### _random_index
|编译选项|作用|
|:--:|:--:|
|--with-http_random_index_moudle|目录中选择一个随机主页|

##### 配置语法
Syntax:random_index on|off;
Default:random_index off;
Context:location

#### 配置步骤
1. 按照如下配置文件进行修改
并在/opt/nginx/app/code2目录下创建不同内容的html文件
```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /opt/nginx/app/code1;
        #index  index.html index.htm;
        random_index on;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
#2.html
<html>
<head>
    <meta charset="utf-8">
    <title>imooc2</title>
</head>
<body style="background-color:black;">
</body>
</html>

#1.html
<html>
<head>
    <meta charset="utf-8">
    <title>imooc1</title>
</head>
<body style="background-color:red;">
</body>
</html>
```
2. 检查配置文件语法格式
nginx -t -c /etc/nginx/nginx.conf
3. 重新加载配置文件
nginx -s reload -c /etc/nginx/nginx.conf
4. 访问如下地址，不断按f5刷新页面
http://106.75.97.163

注：网页文件必须是可见的，否则无效
































