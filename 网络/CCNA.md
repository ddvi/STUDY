[toc]
# CCNA

## 网络基础
无线网络标准 3G 4G 5G WIFI
室外无线覆盖标准 3G 4G 5G
室内无线覆盖标准 WIFI

### 专线
#### 形式
MSTP专线
MPLS专线
==》企业级专线
上下行带宽不对等

#### 定义
总部与分支机构之间的互通

>企业如果需要满足不同地区的公司内部可以互通
跨地域的公司互通
--企业专线
-自己搭建vpn

### 局域网和广域网
#### 局域网
-LAN-局域网-包含N多子网的网络，也可以理解为不经过路由的，或者纯交换网络
-交换机
-IP地址段-同网段
局域网---- 同网段数据转发
同网段---- 查询MAC地址表
数据中心-IDC-Internet Data Center 因特网数据中心
运营商-电信 联通 移动 -SP-Service Provider服务提供商


局域网-依靠MAC地址进行数据转发
MAC地址---物理地址---网卡---出厂自带
记录下来 网卡MAC地址---所有链接下面的PC服务器等等 对端MAC都记录下来 ---MAC地址表

#### 广域网
-WAN-广域网-一般指物理范围很大的地区，例如国家和国家之间的网络，我们平时所说的internet就是最大的广域网
-路由器
-IP地址段-跨网段
广域网---- 跨网段数据转发
跨网段---- 查询路由表

广域网-依靠IP地址进行
IP地址---逻辑地址---自动获得/手动获得
自动获得---DHCP 手动获得---手动配置
宽带（不是DHCP，通过其他方式下发）---地址池---PPOE情况下
跨网段通信---路由器
目的IP----路由表---IP地址转发表
你去哪  怎么走
201.10.138.5---f0/0口出去
135.21.35.10---f1/0口出去
每一条信息 ---路由信息-路由条目

>为何内网ip都是192.168.x.x网段
IANA组织（US）-规划全世界IP地址段-规划一个内网IP地址 全世界任何一个地方的内网都可以使用的 私网IP地址段 
192.168.X.X 规划进去了
局域网和广域网使用网关来界定

### ISP
ISP---Internet Service Provider
因特网服务提供商
移动 联通 电信----一级运营商（基础设施建设权）
-二级运营商
---小区宽带 ----长城宽带 歌华宽带  广电宽带 海泰宽带
社区宽带 ---购买线路 综合布线

### 协议
设备与设备之间通信的语言---TCP/IP协议
TCP/IP协议---地基---血液
OSPF RIP EIGRP协议---轮毂、架构---肢体
FTP HTTP 协议--服务、人---动作

IPX Appletalk

### IP，子网掩码，网关
#### IP--本机标识
IP报头：源目的IP字段
大小 32bit
32bit=4byte  //1M宽带
比特 字节
512k
512kbit/8 ---- 64kbyte
bit--网络单位
byte---存储单位
0-255之间
IPV4版本

>在计算机网络或者是网络运营商中，一般，宽带速率的单位用bps(或b/s)表示；bps表示比特每秒即表示每秒钟传输多少位信息，是bit per second的缩写。在实际所说的1M带宽的意思是1Mbps（是兆比特每秒Mbps不是兆字节每秒MBps）。

#### 掩码--划分网段 
区分我和其他网络内的主机或网关是不是在一个地址段内

#### 网关--下一跳地址 
next-hop via  连接广域网 跨网段数据转发
实际工作中是一台硬件设备，一个接口连接外网，一个接口连接内网，可能是路由器，可能是三层交换机
网关设备与局域网内的其他设备一样，隶属于一个IP地址段内，连接着外网Internet

#### 数据包
大小一般为1500byte---是通用标准---MTU最大传输单元
并不是越大越好，因为网络本身有限速,网络接口的MTU可能达不到，从而造成分片，导致数据传输过程中的不稳定
所以修改MTU并不会使网速变快，需要调整整个链路，统一修改

### IPV4升级IPV6原因
1. 地址不够用
2. arp攻击
3. 包头设计结构复杂，多数字段当前没有实际意义，增加了设备读取数据包消耗时间及资源 

IPV6精简了非常多字段

### 域名
便于记忆
www.baidu.com ---第一步 数据发送到哪里？
发送DNS服务器上进行查询
域名对应的IP地址

8.8.8.8 4.4.4.4 ---全球Google dns地址
114.114.114.114 ---全国比较火的DNS地址

为了提高查询速度，需要了解本地DNS地址并进行配置

#### 域名地址意义
|域名|含义|
|:--:|:--:|
|com|商业机构|
|edu|教育机构|
|gov|政府部门|
|mil|军事机构|
|net|网络组织|
|int|国际机构（主要指北约）|
|org|其他非盈利机构|

### MAC
交换机：连接局域网

switch 交换机
router 路由器
firewall fw 防火墙

交换机只会记录接口对应设备的mac地址---mac地址表（交换机通过数据包源mac确认）

mac地址表保存时间一般为300s，按每个条目计时
一般会将该时间调大至3600s，不然频繁广播更新mac地址表会浪费设备转发性能

局域网--转发相同IP地址段数据的网络 --- 相同IP地址段内

#### arp和mac地址表没有关系
没有
mac是交换机地址的表，记录每一个接口连接对方的mac
arp是终端获取其他设备mac地址而是用的一种协议

### ARP
#### arp协议
地址解析协议---通过ip地址寻找mac地址

如果我的电脑访问的目的IP和我不在一个网段，会自动去找网关mac
乳沟我的电脑访问的目的IP和我在一个网段，会自动去找这个要访问的目的MAC

#### ARP寻找--怎么寻找
1. PC1产生了一条信息  广播信息  内网泛洪查询
请问一下192.168.1.1的mac地址是多少
注：广播和ARP----在IPV6中消失了
2. GW产生的一个单播消息，进行回应 回应PC1
我就是你要找的，我的ip192.168.1.1我的mac是c
3. PC1收到了记录到自己的ARP表，
192.168.1.1-------C
统称为ARP表
PC1在产生实际的业务数据 到达目的
192.168.1.1 可以查询自己的ARP表 进行数据封装

#### ARP攻击
（有时候可以上网有时候不能上网，因为真实PC会正常进行回应）
1. PC1广播 请问一下 网关192.168.1.1的mac地址是多少
2. 欺骗设备进行回复，我就是192.168.1.1的mac地址是G
3. PC1产生了一条信息，目的mac是G，交换机不知道G在哪，继续泛洪

#### ARP攻击判断&处理
1. 抓包
2. arp数量监测，判断接口arp包量，异常则down掉接口 errdisable ------zabbix
3. 静态绑定ip与mac
arp -s ip mac   一般绑定网关
重启失效，一般写入bat文件，开机启动加载

#### arp -a 类型静态与动态的区别
动态  自动对外请求获取，一旦接受arp消息，就会更新arp表
静态不会


#### 无盘启动和arp有无关系
逆向arp---rarp  通过本地mac地址寻找自己的ip地址

### 其他
三层交换机的任何一个接口或者任何一个IP地址，都可以作为管理地址出现

#### 实际工作中远程登录一台网络设备
---telnet 不怎么用 --不加密的,会被抓取到密码
---ssh 经常使用    --加密工具
内网的设备 ------vpn连接到公司 --- ssh 公司内部的网络设备上
客户（公司）网络出问题
驻场--联通电信移动--运营商 分权限 --vpn（PPTP） 公司 SSH设备
简单 检查 调试

## 模拟器
### DynamipsGUI基本使用
#### 配置步骤
1. 安装dynamipsgui（设置默认为管理员权限启动）
2. 安装winpcap
3. 启动dynamipsgui
4. 设置设别类型为3640
3640
是一个路由器但支持交换机模块
（既然可以当路由器也可以当交换机）
5. 导入ios文件（基于原有系统生成路由器，英文路径下）
unzip-c3640-js-mz.124-10.bin
6. 计算idle（未使用管理员运行会闪退）
出现yes/no时
'ctrl + ]'同时按住，一起松手，马上按i

会显示如下信息（寄存器值）
   0x604b99ec (count=23)
   0x604eb190 (count=45)
   0x604ebc1c (count=42)
   0x604ebc58 (count=38)
   0x60593c70 (count=51)
   0x60593ce8 (count=28)
   0x604ec500 (count=38)
   0x604ec6b0 (count=71)
   0x6041f880 (count=63)
   0x6041f8e0 (count=56)

选中count值最大的左侧的值并进行复制
粘贴至idle-pc值处

注：计算idle的原因：
如果idle值计算不对，会导致网络设备运行起来后，cpu，内存飙高，
用于适用不同运行架构，运行一次后续就不用再改

7. 设置虚拟RAM（路由器内存）
默认128M
可以调整为256M（避免运行太多功能导致内存溢出）

8. 点击确定（今后不需要再次修改，重启后选择设备3640即可显示选优配置）

9. 配置输出目录
生成路由器文件的位置

10. 点击下一步进入模块位置
   1>选择设备
   Router1
   2>选择设备类型
   3640
   3>选择模块设置Slot0
   NM-1FE-TX
   4>确认RouterX配置（根据设备数量重复操作
   ）
   5>点击下一步
>注：
>|模块|含义|
>|:--:|:--:|
>|NM-16ESW|交换机模块 16个100M网口|
>|NM-1E|1个10M网口  ethernet以太网接口|
>|NM-4E|4个10M接口 以太网接口|
>|NM-1FE-TX|1个100M口 fastethernet 快速以太网接口|
>|NM-4T|4个T1线路串口  Serial串口 1.544M口|

>Cisco 7200 IOS -G-GigabitEthernet 吉比特以太网接口
>1000M 1G

>10G---XGigabitEthernet---TenGigabitEthernet
>万兆口
11. 连接路由器
选中Router1 F0/0接口
选中Router2 F0/0接口
点击连接
![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-1.png)
12. 点击 “生成.bat文件” 选项
然后点击退出
进入之前配置的输出目录
D:\Soft\DynamipsGUI-outputdir
CONNINFO.TXT ==》记录之前的连接配置信息
![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-2.png)

进入pc1文件夹
运行Router1.bat和Router2.bat，等同于给这两个路由器加电启动
![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-3.png)

![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-4.png)

13. 使用xshell连接路由器
新建链接 
协议选择telnet
端口 
第一台路由器 2001 
2002 2003 2004 2005
第一台交换机 3001 
3002 3003 3004 3005
一次类推

注：使用xshell过程中  可以使用alt + 1/2/3/4进行窗口切换
![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-5.png)
![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-7.png)

初次进入会提示是否要进入初始配置对话框，输入no即可进入
![](http://guanxiaoman.cn-sh2.ufileos.com/CCNA%2FCCNA-8.png)

14. 配置路由器IP

```
#Router1
Router#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#host 1
% Hostname contains one or more illegal characters. 

1(config)#int f0/0
1(config-if)#ip add 10.1.1.1 255.255.255.0
1(config-if)#no sh
1(config-if)#
*Mar  1 01:13:14.403: %LINK-3-UPDOWN: Interface FastEthernet0/0, changed state to up
*Mar  1 01:13:15.403: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/0, changed state to up
1(config-if)#
1(config-if)#end
1#

#Router2
Router>en
Router#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#host 2
% Hostname contains one or more illegal characters. 
2(config)#int f0/0
2(config-if)#ip add 10.1.1.2 255.255.255.0
2(config-if)#no sh
2(config-if)#exit
```

15. 测试连通性
```
#Router1
1#ping 10.1.1.2 repeat 10       

Type escape sequence to abort.
Sending 10, 100-byte ICMP Echos to 10.1.1.2, timeout is 2 seconds:
!!!!!!!!!!
Success rate is 100 percent (10/10), round-trip min/avg/max = 12/30/88 ms
```


注：思科网络设备上中断ping
ctrl + 6

### EVE模拟器基本使用


## OSI
网络标准 ISO 国际标准化组织

### 七层概念
物理层---传输介质，网线568A 568B 线序不同、光纤、板卡、光纤、猫等
A-A B-B
直通线
A-B
交叉线

设备应用----早期设备不支持自动翻转
两种相同类型的设备

-数据链路层---
-网络层---
-传输层---UDP TCP 
------------数据层面  数据流层
会话层
表示层
应用层
------------应用层面






























































