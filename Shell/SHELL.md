# SHELL  
[TOC]
## 变量
### 变量替换
|语法|说明|  
|:--:|:--:|
|${变量名#匹配规则}|从变量开头进行规则匹配，将符合最短的数据删除|
|${变量名##匹配规则}|从变量开头进行规则匹配，将符合最长的数据删除|
|${变量名%匹配规则则}|从变量尾部进行规则匹配，将符合最短的的数据删除|
|${变量名%%匹配规则则}|从变量尾部进行规则匹配，将符合最长的的数据删除|
|${变量名/旧字符串/新字符串}|变量内容符合旧字符串规则，则第一个旧字符串会被新字符串取代|
|${变量名//旧字符串/新字符串}|变量内容符合旧字符串规则，则全部的旧字符串会被新字符串取代|

```
示例
[root@manman ~]# variable_1="I love you,Do you love me"
[root@manman ~]# echo $variable_1 
I love you,Do you love me
[root@manman ~]# var1=${variable_1#*ov}
[root@manman ~]# echo $var1
e you,Do you love me
[root@manman ~]# var2=${variable_1##*ov}
[root@manman ~]# echo $var2
e me
```

### 字符串长度计算
||语法|说明|  
|:--:|:--:|:--:|
|方法一|${#string}|无|
|方法二|expr length "$string"|"string有空格则必须加双引号"|

###获取子串在字符串中的索引位置
|语法|expr index \$string \$substring|
|:--:|:--:|

###子串长度计算
|语法|expr match \$string \$substr|
|:--:|:--:|

> 注：
> 1. 返回的是匹配到的字串的长度, 不是该字符串本身
> 2. 要想匹配成功字串, 这个字串必须是从头开始的, 子串从字符串首部开始才会匹配成功.
> 3. 如果不使用match要想匹配字串, 必须加冒号, 注意这个冒号是放在 字符串的外面的.

### 抽取子串
|语法|说明|  
|:--:|:--:|
|${string:position}|从string中的position开始|
|${string:position:length}|从position开始，长度为length|
|${string: -position}|从右边开始匹配|
|${string:(position)}|从左边开始匹配|
|expr substr \$string \$position $length|从position开始匹配长度为length|

```
[root@manman ~]# var1="kafka hadoop yarn mapreduce"
[root@manman ~]# substr_1=${var1:10}
[root@manman ~]# echo $substr_1 
op yarn mapreduce
[root@manman ~]# substr_2=${var1:10:5}
[root@manman ~]# echo $substr_2
op ya
[root@manman ~]# substr_3=${var1: -5}
[root@manman ~]# echo $substr_3
educe)
[root@manman ~]# substr_4=${var1: -5:2}
[root@manman ~]# echo $substr_4
ed
```
> 注意：使用expr，索引计数是从1开始计算，使用${sring:position},索引计数是从0开始计数

### 示例脚本
```
[vagrant@docker-host shell]$ cat example.sh 
#!/bin/bash
#字符串处理脚本
string="Bigdata process framework is Hadoop,Hadoop is an open source project"
function print_tips
{
	echo "*****************************************"
	echo "(1)打印string长度"
	echo "(2)删除字符串中的所有Hadoop"
	echo "(3)替换第一个Hadoop为Mapreduce"
	echo "(4)替换全部的Hadoop为Mapreduce"
	echo "*****************************************"
}

function len_of_string
{
	echo "${#string}"
}

function del_hadoop
{
	echo "${string//Hadoop/}"
}

function rep_hadoop_mapreduce_first
{
	echo "${string/Hadoop/Mapreduce}"
}

function rep_hadoop_mapreduce_all
{
	echo "${string//Hadoop/Mapreduce}"
}

while true
do
	echo "【string=$string】"
	echo
	print_tips
	read -p "Please input your choice (1|2|3|4|q|Q): " choice
	
	case $choice in
		1)
			len_of_string
			;;
		2)
			del_hadoop
			;;
		3)
			rep_hadoop_mapreduce_first
			;;
		4)
			rep_hadoop_mapreduce_all
			;;
		q|Q)
			exit
			;;
		*)
			echo "ERROR,input only in {1|2|3|4|q|Q}"
			;;
	esac
done
```
***
## 命令替换

||语法|  
|:--:|:--:|
|方法一|\`command`|
|方法二|\$(command)|

```
例1	获取系统所有用户并输出
[vagrant@docker-host shell]$ cat example_1.sh 
#!/bin/bash
#

index=1

for user in `cat /etc/passwd | cut -d ":" -f 1`
do
	echo "This is $index user: $user"
	index=$(($index + 1))
done

例2	根据系统时间计算今年或明年
echo "This is $(date +%Y) year"
echo "This is $(($(date +%Y) + 1)) year"

例3	根据系统时间计算今年还剩下多少星期，已经过了多少星期
date +%j
echo "This year have passed $(date +%j) days"
echo "This yest have passed $((10#$(date +%j)/7)) weeks"
echo "There is $((365 - 10#$(date +%j))) days before new year"
echo "There is $(((365 - 10#$(date +%j))/7)) weeks before new year"

以0开头的数字 系统会默认识别为八进制数，所以我的 $datem-1这样的获取上个月的月份是回报:value too great for base (error token is "08")这个错误的，解决办法就是
将$datem格式或者声明称十进制，`10#$datem`-1  这样就可以了。  也就是将要转换成十进制的变量或者数字 在前面加上`10#`即可:

例4	判定nginx进程是否存在，若不存在自动拉起进程
#!/bin/bash
#

nginx_process_num=$(ps -ef | grep nginx | grep -v grep |wc -l)

if [ $nginx_process_num -eq 0 ];then
        systemctl start nginx
fi
```
> 总结：``和$()是等价的，但是推荐初学者使用$()，易于掌握；缺点是极少数unix可能不支持，但是``是支持的
$(())主要是用来进行整数运算，包括加减乘除，引用变量前面可以加$,也可以不加$
shell不严谨的一种体现
***
## 有类型变量
> shell为弱类型，先不先定义变量类型均可。支持提前声明
declare和typeset
declare和typeset命令两者等价
declare和typeset命令都是用来定义变量类型的
shell默认将变量作为字符串来处理
###declare
|参数|含义|  
|:--:|:--:|
|-r|将变量设为只读|
|-i|将变量设为整数|
|-a|将变量定义为数组|
|-f|显示此脚本前定义过的所有函数内容|
|-F|仅显示此脚本前定义过的函数名|
|-x|将变量声明为环境变量,可以在脚本中直接使用
|

```
##declare -r     #声明变量为只读类型
declare -r var="hello"
var="world"      -bash: var: readonly variable
declare +x var  取消声明

##declare -i       #声明变量为整型
num1=2001
num2=$num1+1
echo $num2

declare -i num2
num2=$num1+1
echo $num2
```

> declare -a
数组下标从0开始
array=("jones" "mike" "kobe" "jordan")
输出数组内容：
echo ${array[@]}		输出全部内容
echo ${array[1]}		输出下标索引为1的内容
获取数组长度：
echo \${#array}			数组内元素个数
echo \${#array[2]}		数组内下标索引为2的元素长度
给数组某个下标赋值：
                    array[0]="lily"		    给数组下标索引为1的元素赋值为lily
      array[20]=“hanmeimei”   在数组尾部添加一个新元素
删除元素：
     unset array[2]                   清除元素
    unset array                        清空整个数组
分片访问：
    ${array[@]:1:4}                  显示数组下标索引从1到3的3个元素不显
内容替换：
    \${array[@]/an/AN}            将数组中所有元素包含lobe的子串替换为mcg
数组遍历：
   for v in ${array[@]}
   do
   	echo $v
  done

  > 取消声明变量：
declare +r
declare +i
declare +a
declare +x
***
## 数学运算expr bc
### expr
||语法|  
|:--:|:--:|
|方法一|expr \$num1 operator $num2|
|方法二|$(($num1 operator $num2))|

|操作符|含义|  
|:--:|:--:|
|num1 \| num2|num1不为空且非0，返回num1，否则返回num2|
|num1 & num2|num1不为空且非0，返回num1，否则返回0|
|num1 < num2|num1小于num2，返回1，否则返回0|
|num1 <= num2|num1小于等于num2，返回1，否则返回0|
|num1 = num2|num1等于num2，返回1，否则返回0|
|num1 != num2|num1不等于num2，返回1，否则返回0|
|num1 > num2|num1大于num2，返回1，否则返回0|
|num1 >= num2|num1大于等于num2，返回1，否则返回0|
|||
|num1 + num2|求和|
|num1 - num2|求差|
|num1 * num2|求积|
|num1 / num2|求商|
|num1 % num2|求余|


> 使用expr命令进行运算
>1. |管道在shell中是默认保留的关键字，直接使用会报错，进行数据运算必须进行转义 \
\> < * 均是
使用\$(())进行运算则不需要转义
>2. expr命令仅支持整数运算
>3. 使用expr命令进行比较，为真返回1.为假返回0，和shell终端上执行命令时恰好相反（）
且仅支持整数比较，浮点数比较不支持
>4. 使用\$(())进行运算需要同步赋值给变量，这不是一个合法的命令，不能单独被执行
>5. expr命令语法不严谨，使用expr做算术运算时，第一个变量可以为空或不定义，但第二个必须是已定义的变量或常量，记住即可！shell中还有其他的算术运算方法，比如使用双引号

>其他
> 1. 使用echo $? 查看最近一个使用命令是否成功执行
> 2. \$(())  避免用于大小比较，只用于加减乘除
> 3. -eq           //等于
-ne           //不等于
-gt            //大于 （greater ）
-lt            //小于  （less）
-ge            //大于等于
-le            //小于等于
命令的逻辑关系：
在linux 中 命令执行状态：0 为真，其他为假
逻辑与： &&
第一个条件为假时，第二条件不用再判断，最终结果已经有；
第一个条件为真时，第二条件必须得判断；
逻辑或： ||
逻辑非： ！
> 4. &> /dev/null
> 5. break是立马跳出循环；continue是跳出当前条件循环，继续下一轮条件循环；exit是直接退出整个脚本

>示例
提示一个用户输入正整数sum，然后计算1+2+3+...+sum的值；必须对sum是否为正整数做出判断，不符合应当允许再次输入。
判断是否为正整数：
1、判断是否为整数：能否使用expr命令进行运算
2、判断是否大于0： 使用expr命令比较是否大于0

```
#!/bin/bash
#
while true
do
        read -p "Pls input positive integer (num>0): " num
        expr $num + 1 &> /dev/null
        if [ $? -eq 0 ];then
                if [ `expr $num \> 0` -eq 1 ];then
                        for ((i=1;i<=$num;i++))
                        do
                                sum=`expr $sum + $i`
                        done
                        echo "1+2+...+$num=$sum"
                        exit
                else
                        echo "您输入整数小于0，请重新输入"
                fi
        else
                echo "您输入的不是整数，请重新输入"
        fi
done
```

### bc
>bc是bash内建的运算器，支持浮点运算
内建变量scale可以设置，默认为0
scale 精确度

|操作符|含义|  
|:--:|:--:|
|num1 + num2|求和|
|num1 - num2|求差|
|num1 * num2|求积|
|num1 / num2|求商|
|num1 % num2|求余|
|num1 ^ num2|指数运算|

```
[root@manman ~]# bc
bc 1.06.95
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
23/7
3
scale=2
23/7
3.28
scale=6
23/7
3.285714
```

> 在脚本中使用bc需要用echo将参数同通过管道传给bc
```
[root@manman ~]# echo "22+33" | bc
55
[root@manman ~]# echo "22.3+33" | bc
55.3
[root@manman ~]# echo "scale=6;22.3/3.5" | bc
6.371428
```
***
## 函数
### 定义和使用
>将经常使用的功能封装起来==》函数
提高代码复用性可维护性

|第一种格式|name()<br>{<br>　　command1<br>　　command2<br>　　......<br>   　　commandn<br>}|  
|:--:|:--|

### 调用
>1. 直接使用函数名称调用，可以将其想象成shell中的一条命令
>2. 函数内部可以直接使用参数\$1 \$2 ...\$n
>3. 调用函数：function_name \$1 \$2
>4. \$# 是传给脚本的参数个数
\$0 是脚本本身的名字
\$1 是传递给该shell脚本的第一个参数
\$2 是传递给该shell脚本的第二个参数
\$@ 是传给脚本的所有参数的列表
\$* 是以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9个
\$$ 是脚本运行的当前进程ID号，在非root环境下会有问题
\$? 是显示最后命令的退出状态，0表示没有错误，其他表示有错误
####代码示例
```
print_num () 
{ 
    for ((i=0; i<=10; i++))
    do
        echo -n "$i";
    done
}
```
```
#需求描述：写一个nginx监控脚本，如果nginx服务down掉，则该脚本可以检测到，并将进程启动，放在后台执行
#ngninx安装：https://nginx.org/en/linux_packages.html#RHEL-CentOS
#!/bin/bash
#
this_pid=$$
while true
do
ps -ef | grep nginx | grep -v grep | grep -v $this_pid &> /dev/null

if [ $? -eq 0 ];then
        echo "Nginx is running well"
        sleep 3
else
        systemctl start nginx
        echo "Nginx is down,start it"
fi
done

```
>将脚本作为守护进程在后台执行
nohup sh nginx_daemon.sh &
nohub 和 &
使用&后台运行程序：
结果会输出到终端
使用Ctrl + C发送SIGINT信号，程序免疫
关闭session发送SIGHUP信号，程序关闭
使用nohup运行程序：
结果默认会输出到nohup.out，在当前目录下
使用Ctrl + C发送SIGINT信号，程序关闭
关闭session发送SIGHUP信号，程序免疫
平日线上经常使用nohup和&配合来启动程序：
同时免疫SIGINT和SIGHUP信号

### 传参
|function name<br>{<br>　　echo "hello \$1"<br>　　echo "hello $2"<br>}|  
|:--|

|函数调用 : name Lily Allen|  
|:--|

#### 示例
> 需求描述：写一个脚本，该脚本可以实现计算器功能，可以进行加减乘除四种运算。
                例如 
				sh calsulate,sh 30 + 40 
                sh calsulate,sh 30 - 40

```
#!/bin/bash
#

function calculate
{
        case $2 in
                +)
                        echo "`expr $1 + $3`"
                        ;;
                -)
                        echo "`expr $1 - $3`"
                        ;;
                \\*)
                        echo "`expr $1 \\* $3`"
                        ;;
                /)
                        echo "`expr $1 / $3`"
                        ;;
        esac
}

calculate $1 $2 $
```
### 返回值

|||
|:--:|:--:|
|方法一|return|
|方法二|echo|

>1. 使用return返回值，只能返回1-255的整数
函数使用return返回值，用长只是用来供其他地方调用获取状态，因此通常仅返回0或者1；0表示成功，1表示失败
>2. 使用echo返回值
可以返回任何字符串结果
通常用于返回数据，比如一个字符串或者列表值

```
#!/bin/bash
#

this_pid=$$

function is_nginx_running
{
        ps -ef | grep nginx | grep -v grep |grep -v $this_pid &> /dev/null
        if [ $? -eq 0 ];then
                return 0
        else
                return 1
        fi
}

is_nginx_running && echo "Nginx is running" || echo " Nginx is stoped"
======================================================================

#!/bin/bash
#

function get_users
{
        users=`cat /etc/passwd | cut -d : -f 1`
        echo $users
}

user_list=`get_users`
index=1
for u in $user_list
do
        echo "The $index user is : $u"
        index=$(($index+1))
done

```

#### 补充-shell中&&和||的使用方法
>&&运算符:
command1  && command2
&&左边的命令（命令1）返回真(即返回0，成功被执行）后，&&右边的命令（命令2）才能够被执行；换句话说，“如果这个命令执行成功&&那么执行这个命令”。 
语法格式如下：
    command1 && command2 [&& command3 ...]
1 命令之间使用 && 连接，实现逻辑与的功能。
2 只有在 \&& 左边的命令返回真（命令返回值 \$? == 0），&& 右边的命令才会被执行。
3 只要有一个命令返回假（命令返回值 \$? == 1），后面的命令就不会被执行。
示例 1
malihou@ubuntu:~\$ cp ~/Desktop/1.txt ~/1.txt && rm ~/Desktop/1.txt && echo "success"
示例 1 中的命令首先从 ~/Desktop 目录复制 1.txt 文件到 ~ 目录；执行成功后，使用 rm 删除源文件；如果删除成功则输出提示信息。
||运算符:
command1 || command2
||则与&&相反。如果||左边的命令（命令1）未执行成功，那么就执行||右边的命令（命令2）；或者换句话说，“如果这个命令执行失败了||那么就执行这个命令。
1 命令之间使用 || 连接，实现逻辑或的功能。
2 只有在 || 左边的命令返回假（命令返回值 $? == 1），|| 右边的命令才会被执行。这和 c 语言中的逻辑或语法功能相同，即实现短路逻辑或操作。
3 只要有一个命令返回真（命令返回值 $? == 0），后面的命令就不会被执行。
示例 2
malihou@ubuntu:~$ rm ~/Desktop/1.txt || echo "fail"
在示例 2 中，如果 ~/Desktop 目录下不存在文件 1.txt，将输出提示信息。
示例 3
malihou@ubuntu:~$ rm ~/Desktop/1.txt && echo "success" || echo "fail"
在示例 3 中，如果 ~/Desktop 目录下存在文件 1.txt，将输出 success 提示信息；否则输出 fail 提示信息。






























