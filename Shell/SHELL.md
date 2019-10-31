# SHELL  
[TOC]
## 命令

### source
source 是 Shell 内置命令的一种，它会读取脚本文件中的代码，并依次执行所有语句。你也可以理解为，source 命令会强制执行脚本文件中的全部命令，而忽略脚本文件的权限。

#### 用法：
```
source filename
#. filename
```
两种写法的效果相同。对于第二种写法，注意点号.和文件名中间有一个空格。

### 内建命令
由 Bash 自身提供的命令，而不是文件系统中的某个可执行文件。
可以使用 type 来确定一个命令是否是内建命令：
```
[root@localhost ~]# type cd
cd is a Shell builtin
[root@localhost ~]# type ifconfig
ifconfig is /sbin/ifconfig
```

### alise
#### 设置别名
```
alias new_name='command'
```
#### 删除别名
使用 unalias 内建命令可以删除当前 Shell 进程中的别名。unalias 有两种使用方法：
第一种用法是在命令后跟上某个命令的别名，用于删除指定的别名。
第二种用法是在命令后接-a参数，删除当前 Shell 进程中所有的别名。
同样，这两种方法都是在当前 Shell 进程中生效的。要想永久删除配置文件中定义的别名，只能进入该文件手动删除。

### echo
是一个 Shell 内建命令，用来在终端输出字符串，并在最后默认加上换行符。

echo 命令输出结束后默认会换行，如果不希望换行，可以加上-n参数

默认情况下，echo 不会解析以反斜杠\开头的转义字符。比如，\n表示换行，echo 默认会将它作为普通字符对待。
不过我们可以添加-e参数来让 echo 命令解析转义字符。
```
[root@localhost ~]# echo "hello \nworld"
hello \nworld

[root@localhost ~]# echo -e "hello \nworld"
hello
world
```

###　read
####　定义
用来从标准输入中读取数据并赋值给变量。如果没有进行重定向，默认就是从键盘读取用户输入的数据；如果进行了重定向，那么可以从文件中读取数据。
####　格式
```
read [-options] [variables]
```
options表示选项，如下表所示；variables表示用来存储数据的变量，可以有一个，也可以有多个。

options和variables都是可选的，如果没有提供变量名，那么读取的数据将存放到环境变量 REPLY 中。

|选项|说明|
|:--:|:--:|
|-a array|把读取的数据赋值给数组 array，从下标 0 开始。|
|-d delimiter|用字符串 delimiter 指定读取结束的位置，而不是一个换行符（读取到的数据不包括 delimiter）。|
|-e|在获取用户输入的时候，对功能键进行编码转换，不会直接显式功能键对应的字符。|
|-n num|读取 num 个字符，而不是整行字符。|
|-p prompt|显示提示信息，提示内容为 prompt。|
|-r|原样读取（Raw mode），不把反斜杠字符解释为转义字符。|
|-s|静默模式（Silent mode），不会在屏幕上显示输入的字符。当输入密码和其它确认信息的时候，这是很有必要的。|
|-t seconds|设置超时时间，单位为秒。如果用户没有在指定时间内输入完成，那么 read 将会返回一个非 0 的退出状态，表示读取失败。|
|-u fd|使用文件描述符 fd 作为输入源，而不是标准输入，类似于重定向。|

```
!/bin/bash
read -p "Enter some information " name url age
echo "网站名字：$name"
echo "网址：$url"
echo "年龄：$age"
```
注意，必须在一行内输入所有的值，不能换行，否则只能给第一个变量赋值，后续变量都会赋值失败。
```
#-n 1表示只读取一个字符。运行脚本后，只要用户输入一个字符，立即读取结束，不用等待用户按下回车键。
#!/bin/bash
read -n 1 -p "Enter a char > " char
printf "\n"  #换行
echo $char
```

```
#在指定时间内输入密码。
#!/bin/bash
if
    read -t 20 -sp "Enter password in 20 seconds(once) > " pass1 && printf "\n" &&  #第一次输入密码
    read -t 20 -sp "Enter password in 20 seconds(again)> " pass2 && printf "\n" &&  #第二次输入密码
    [ $pass1 == $pass2 ]  #判断两次输入的密码是否相等
then
    echo "Valid password"
else
    echo "Invalid password"
fi
```

### exit
用来退出当前 Shell 进程，并返回一个退出状态；使用$?可以接收这个退出状态  
exit 命令可以接受一个整数值作为参数，代表退出状态。如果不指定，默认状态值是 0。  
一般情况下，退出状态为 0 表示成功，退出状态为非 0 表示执行失败（出错）了。  
exit 退出状态只能是一个介于 0~255 之间的整数，其中只有 0 表示成功，其它值都表示失败。  
Shell 进程执行出错时，可以根据退出状态来判断具体出现了什么错误，比如打开一个文件时，我们可以指定 1 表示文件不存在，2 表示文件没有读取权限，3 表示文件类型不对。  


## 变量
在 Bash shell 中，每一个变量的值都是字符串，无论你给变量赋值时有没有使用引号，值都会以字符串的形式存储
这意味着，Bash shell 在默认情况下不会区分变量类型，即使你将整数和小数赋值给变量，它们也会被视为字符串，这一点和大部分的编程语言不同。  
如果有必要，你也可以使用 Shell declare 关键字显式定义变量的类型

### 定义
字母数字下划线组成
数字不可以放在开头
大小写敏感

### 类型
数字 字符 list数组

### 使用变量
使用一个定义过的变量，只要在变量名前面加美元符号$即可，如：
```
author="严长生"
echo $author
echo ${author}
```
变量名外面的花括号{ }是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界，比如下面这种情况：
```
skill="Java"
echo "I am good at ${skill}Script"
```
如果不给 skill 变量加花括号，写成echo "I am good at $skillScript"，解释器就会把 $skillScript 当成一个变量（其值为空），代码执行结果就不是我们期望的样子了。

推荐给所有变量加上花括号{ }，这是个良好的编程习惯。

### 只读变量
使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。

下面的例子尝试更改只读变量，结果报错：
```
#!/bin/bash
myUrl="http://c.biancheng.net/shell/"
readonly myUrl
myUrl="http://c.biancheng.net/shell/"
```
运行脚本，结果如下：
```
bash: myUrl: This variable is read only.
```

### 删除变量
unset

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
## 数组
数组（Array）是若干数据的集合，其中的每一份数据都称为元素（Element）。
Shell 并且没有限制数组的大小，理论上可以存放无限量的数据。和 C++、Java、C# 等类似，Shell 数组元素的下标也是从 0 开始计数。
获取数组中的元素要使用下标[ ]，下标可以是一个整数，也可以是一个结果为整数的表达式；当然，下标必须大于等于 0。
常用的 Bash Shell 只支持一维数组，不支持多维数组。

### 定义
在 Shell 中，用括号()来表示数组，数组元素之间用空格来分隔。由此，定义数组的一般形式为：
```
array_name=(ele1  ele2  ele3 ... elen)
```
注意，赋值号=两边不能有空格，必须紧挨着数组名和数组元素。

下面是一个定义数组的实例：
```
nums=(29 100 13 8 91 44)
```
Shell 是弱类型的，它并不要求所有数组元素的类型必须相同，例如：
```
arr=(20 56 "http://c.biancheng.net/shell/")
```
第三个元素就是一个“异类”，前面两个元素都是整数，而第三个元素是字符串。

Shell 数组的长度不是固定的，定义之后还可以增加元素。例如，对于上面的 nums 数组，它的长度是 6，使用下面的代码会在最后增加一个元素，使其长度扩展到 7：
```
nums[6]=88
```
此外，你也无需逐个元素地给数组赋值，下面的代码就是只给特定元素赋值：
```
ages=([3]=24 [5]=19 [10]=12)
```
以上代码就只给第 3、5、10 个元素赋值，所以数组长度是 3。

### 获取数组元素
获取数组元素的值，一般使用下面的格式：
```
${array_name[index]}
```
其中，array_name 是数组名，index 是下标。例如：
```
n=${nums[2]}
```
表示获取 nums 数组的第二个元素，然后赋值给变量 n。再如：
```
echo ${nums[3]}
```
表示输出 nums 数组的第 3 个元素。
使用@或*可以获取数组中的所有元素，例如：
```
${nums[*]}
${nums[@]}
```
两者都可以得到 nums 数组的所有元素。

完整的演示：
```
#!/bin/bash
nums=(29 100 13 8 91 44)
echo ${nums[@]}  #输出所有数组元素
nums[10]=66  #给第10个元素赋值（此时会增加数组长度）
echo ${nums[*]}  #输出所有数组元素
echo ${nums[4]}  #输出第4个元素
```
运行结果：
29 100 13 8 91 44
29 100 13 8 91 44 66
91

### 获取数组长度
所谓数组长度，就是数组元素的个数。
利用@或*，可以将数组扩展成列表，然后使用#来获取数组元素的个数，格式如下：
```
${#array_name[@]}
${#array_name[*]}
```
其中 array_name 表示数组名。两种形式是等价的，选择其一即可。
如果某个元素是字符串，还可以通过指定下标的方式获得该元素的长度，如下所示：
```
${#arr[2]}
```
获取 arr 数组的第 2 个元素（假设它是字符串）的长度。

#### 示例
下面我们通过实际代码来演示一下如何获取数组长度。
```
#!/bin/bash
nums=(29 100 13)
echo ${#nums[*]}
#向数组中添加元素
nums[10]="http://c.biancheng.net/shell/"
echo ${#nums[@]}
echo ${#nums[10]}
#删除数组元素
unset nums[1]
echo ${#nums[*]}
```
运行结果：
3
4
29
3

### 数组拼接
所谓 Shell 数组拼接（数组合并），就是将两个数组连接成一个数组。
拼接数组的思路是：先利用@或*，将数组扩展成列表，然后再合并到一起。具体格式如下：
```
#!/bin/bash
array1=(23 56)
array2=(99 "http://c.biancheng.net/shell/")
array_new=(${array1[@]} ${array2[*]})
echo ${array_new[@]}  #也可以写作 ${array_new[*]}
```
运行结果：
23 56 99 http://c.biancheng.net/shell/

### 删除数组元素
在 Shell 中，使用 unset 关键字来删除数组元素，具体格式如下：
```
unset array_name[index]
```
其中，array_name 表示数组名，index 表示数组下标。
如果不写下标，而是写成下面的形式：
```
unset array_name
```

那么就是删除整个数组，所有元素都会消失。

下面我们通过具体的代码来演示：
```
#!/bin/bash
arr=(23 56 99 "http://c.biancheng.net/shell/")
unset arr[1]
echo ${arr[@]}
unset arr
echo ${arr[*]}
```
运行结果
23 99 http://c.biancheng.net/shell/

注意最后的空行，它表示什么也没输出，因为数组被删除了，所以输出为空。
***
## 命令替换
### 定义
命令替换是指将命令的输出结果赋值给某个变量
### 语法
||语法|  
|:--:|:--:|
|方法一|\`command`|
|方法二|\$(command)|
### 注意事项
如果被替换的命令的输出内容包括多行（也即有换行符），或者含有多个连续的空白符，那么在输出变量时应该将变量用双引号包围，否则系统会使用默认的空白符来填充，这会导致换行无效，以及连续的空白符被压缩成一个。
```
#!/bin/bash
LSL=`ls -l`
echo $LSL  #不使用双引号包围
echo "--------------------------"  #输出分隔符
echo "$LSL"  #使用引号包围
```
运行结果
```
total 8 drwxr-xr-x. 2 root root 21 7月 1 2016 abc -rw-rw-r--. 1 mozhiyan mozhiyan 147 10月 31 10:29 demo.sh -rw-rw-r--. 1 mozhiyan mozhiyan 35 10月 31 10:20 demo.sh~
--------------------------
total 8
drwxr-xr-x. 2 root     root      21 7月   1 2016 abc
-rw-rw-r--. 1 mozhiyan mozhiyan 147 10月 31 10:29 demo.sh
-rw-rw-r--. 1 mozhiyan mozhiyan  35 10月 31 10:20 demo.sh~
```
所以，为了防止出现格式混乱的情况，建议在输出变量时加上双引号。

### 再谈反引号和 $()
原则上讲，上面提到的两种变量替换的形式是等价的，可以随意使用；但是，反引号毕竟看起来像单引号，有时候会对查看代码造成困扰，而使用 \$() 就相对清晰，能有效避免这种混乱。而且有些情况必须使用 \$()：\$() 支持嵌套，反引号不行。
不过要注意的是，\$() 仅在 Bash Shell 中有效，而反引号可在多种 Shell 中使用。

下面的例子演示了使用计算 ls 命令列出的第一个文件的行数，这里使用了两层嵌套。
```
[root@manman shell]# cat 1.txt 
'6000'
'500'
6000
[root@manman shell]# Fir_File_Lines=$(wc -l $(ls | sed -n '1p'))
[root@manman shell]# echo "$Fir_File_Lines"
3 1.txt
```

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
## 数学运算\(()) expr bc
### \(())
双小括号 (( )) 是 Bash Shell 中专门用来进行整数运算的命令，它的效率很高，写法灵活，是企业运维中常用的运算命令。
注意：(( )) 只能进行整数运算，不能对小数（浮点数）或者字符串进行运算。后续讲到的 bc 命令可以用于小数运算。

#### 格式

```
((表达式))
```
通俗地讲，就是将数学运算表达式放在\((和))之间。

表达式可以只有一个，也可以有多个，多个表达式之间以逗号,分隔。对于多个表达式的情况，以最后一个表达式的值作为整个 (( )) 命令的执行结果。

可以使用$获取 (( )) 命令的结果，这和使用$获得变量值是类似的。
```
#利用 (( )) 进行简单的数值计算。
[c.biancheng.net]$ echo $((1+1))
2
[c.biancheng.net]$ echo $((6-3))
3
[c.biancheng.net]$ i=5
[c.biancheng.net]$ ((i=i*2))  #可以简写为 ((i*=2))。
[c.biancheng.net]$ echo $i   #使用 echo 输出变量结果时要加 $。
10

#【实例2】用 (( )) 进行稍微复杂一些的综合算术运算。
[c.biancheng.net]$ ((a=1+2**3-4%3))
[c.biancheng.net]$ echo $a
8
[c.biancheng.net]$ b=$((1+2**3-4%3)) #运算后将结果赋值给变量，变量放在了括号的外面。
[c.biancheng.net]$ echo $b
8
[c.biancheng.net]$ echo $((1+2**3-4%3)) #也可以直接将表达式的结果输出，注意不要丢掉 $ 符号。
8
[c.biancheng.net]$ a=$((100*(100+1)/2)) #利用公式计算1+2+3+...+100的和。
[c.biancheng.net]$ echo $a
5050
[c.biancheng.net]$ echo $((100*(100+1)/2)) #也可以直接输出表达式的结果。
5050

#【实例3】利用 (( )) 进行逻辑运算。
[c.biancheng.net]$ echo $((3<8))  #3<8 的结果是成立的，因此，输出了 1，1 表示真
1
[c.biancheng.net]$ echo $((8<3))  #8<3 的结果是不成立的，因此，输出了 0，0 表示假。
0
[c.biancheng.net]$ echo $((8==8)) #判断是否相等。
1
[c.biancheng.net]$ if ((8>7&&5==5))
> then
> echo yes
> fi
yes

#【实例4】利用 (( )) 进行自增（++）和自减（--）运算。
[c.biancheng.net]$ a=10
[c.biancheng.net]$ echo $((a++))  #如果++在a的后面，那么在输出整个表达式时，会输出a的值,因为a为10，所以表达式的值为10。
10
[c.biancheng.net]$ echo $a #执行上面的表达式后，因为有a++，因此a会自增1，因此输出a的值为11。
11
[c.biancheng.net]$ a=11
[c.biancheng.net]$ echo $((a--)) #如果--在a的后面，那么在输出整个表达式时，会输出a的值，因为a为11，所以表达式的值的为11。
11
[c.biancheng.net]$ echo $a #执行上面的表达式后，因为有a--，因此a会自动减1，因此a为10。
10
[c.biancheng.net]$ a=10
[c.biancheng.net]$ echo $((--a))  #如果--在a的前面，那么在输出整个表达式时，先进行自增或自减计算，因为a为10，且要自减，所以表达式的值为9。
9
[c.biancheng.net]$ echo $a #执行上面的表达式后，a自减1,因此a为9。
9
[c.biancheng.net]$ echo $((++a))  #如果++在a的前面，输出整个表达式时，先进行自增或自减计算，因为a为9，且要自增1，所以输出10。
10
[c.biancheng.net]$ echo $a  #执行上面的表达式后，a自增1,因此a为10。
10

#实例5】利用 (( )) 同时对多个表达式进行计算。
[c.biancheng.net]$ ((a=3+5, b=a+10))  #先计算第一个表达式，再计算第二个表达式
[c.biancheng.net]$ echo $a $b
8 18
[c.biancheng.net]$ c=$((4+8, a+b))  #以最后一个表达式的结果作为整个(())命令的执行结果
[c.biancheng.net]$ echo $c
26
```

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
### 常用的6种数学计算方式
|运算操作符/运算命令|说明|
|:--:|:--:|
|\(())|用于整数运算，效率很高，推荐使用|
|let|用于证书运算，和\(())类似|
|$[]|用于整数计算，不如\(())灵活|
|expr|可用于证书计算，也可以处理字符串。比较麻烦，需要注意各种细节，不推荐使用|
|bc|linux下的一个计算机程序，可以处理整数和小数。shell本身只支持整数运算，想计算小数就得使用bc这个外部的计算器|
|declare -i|将变量定义为整数，然后再进行数学计算是就不会当字符串了。功能有限，仅支持最基本的数学运算（加减乘除和取余），不支持逻辑运算、自增自减等，所以在实际开发中很少使用|

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
0}
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
运行 Shell 脚本文件时我们可以给它传递一些参数，这些参数在脚本文件内部可以使用$n的形式来接收，例如，$1 表示第一个参数，$2 表示第二个参数，依次类推。

同样，在调用函数时也可以传递参数。Shell 函数参数的传递和其它编程语言不同，没有所谓的形参和实参，在定义函数时也不用指明参数的名字和数目。换句话说，定义 Shell 函数时不能带参数，但是在调用函数时却可以传递参数，这些传递进来的参数，在函数内部就也使用$n的形式接收，例如，$1 表示第一个参数，$2 表示第二个参数，依次类推。

这种通过$n的形式来接收的参数，在 Shell 中称为位置参数。

如果参数个数太多，达到或者超过了 10 个，那么就得用\${n}的形式来接收了，例如 \${10}、\${23}。{ }的作用是为了帮助解释器识别参数的边界，这跟使用变量时加{ }是一样的效果

#### 格式
|function name<br>{<br>　　echo "hello \$1"<br>　　echo "hello $2"<br>}|  
|:--|

|函数调用 : name Lily Allen|  
|:--|

#### 特殊变量
|变量|含义|  
|:--:|:--:|
|$0|当前脚本文件名|
|$n(n>=1)|传递给脚本或函数的参数。n是一个数字，表示第几个参数。例如，第一个参数是$1,第二个参数是$2|
|$#|传递给脚本或函数的参数个数|
|$*|传递给脚本或函数的所有参数|
|$@|传递给脚本或函数的所有参数，当被双引号" "包含时，\$\@ 与 \$\* 稍有不同。详见\$@和\$*区别|
|$?|上个命令的退出状态，或函数的返回值|
|$$|当前shell进程ID|

#### \$*和\$@之间的区别
\$* 和 \$@ 都表示传递给函数或脚本的所有参数，我们已在《Shell特殊变量》一节中进行了演示，本节重点说一下它们之间的区别。

当 \$* 和 \$@ 不被双引号" "包围时，它们之间没有任何区别，都是将接收到的每个参数看做一份数据，彼此之间以空格来分隔。

但是当它们被双引号" "包含时，就会有区别了：
"\$*"会将所有的参数从整体上看做一份数据，而不是把每个参数都看做一份数据。
"\$@"仍然将每个参数都看作一份数据，彼此之间是独立的。

比如传递了 5 个参数，那么对于"$*"来说，这 5 个参数会合并到一起形成一份数据，它们之间是无法分割的；而对于"\$@"来说，这 5 个参数是相互独立的，它们是 5 份数据。

如果使用 echo 直接输出"\$*"和"\$@"做对比，是看不出区别的；但如果使用 for 循环来逐个输出数据，立即就能看出区别来。
编写下面的代码，并保存为 test.sh：
```
#!/bin/bash
echo "print each param from \"\$*\""
for var in "$*"
do
    echo "$var"
done
echo "print each param from \"\$@\""
for var in "$@"
do
    echo "$var"
done
```
运行 test.sh，并附带参数：
```
[mozhiyan@localhost demo]$ . ./test.sh a b c d
print each param from "$*"
a b c d
print each param from "$@"
a
b
c
d
```
从运行结果可以发现，对于"\$*"，只循环了 1 次，因为它只有 1 分数据；对于"\$@"，循环了 5 次，因为它有 5 份数据。

#### \$?
$? 是一个特殊变量，用来获取上一个命令的退出状态，或者上一个函数的返回值。

所谓退出状态，就是上一个命令执行后的返回结果。退出状态是一个数字，一般情况下，大部分命令执行成功会返回 0，失败返回 1

##### 获取上一个命令的退出状态
```
#!/bin/bash
if [ "$1" == 100 ]
then
   exit 0  #参数正确，退出状态为0
else
   exit 1  #参数错误，退出状态1
fi
```
exit表示退出当前 Shell 进程，我们必须在新进程中运行 test.sh，否则当前 Shell 会话（终端窗口）会被关闭，我们就无法取得它的退出状态了。

##### 获取函数返回值
```
#!/bin/bash
#得到两个数相加的和
function add(){
    return `expr $1 + $2`
}
add 23 50  #调用函数
echo $?  #获取函数返回值
```
运行结果：
73

注：有 C++、C#、Java 等编程经验的读者请注意：严格来说，Shell 函数中的 return 关键字用来表示函数的退出状态，而不是函数的返回值；Shell 不像其它编程语言，没有专门处理返回值的关键字。

以上处理方案在其它编程语言中没有任何问题，但是在 Shell 中是非常错误的，Shell 函数的返回值和其它编程语言大有不同，我们将在《Shell函数返回值》中展开讨论。

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
1 命令之间使用 \&& 连接，实现逻辑与的功能。  
2 只有在 \&& 左边的命令返回真（命令返回值 \$? \== 0），&& 右边的命令才会被执行。  
3 只要有一个命令返回假（命令返回值 \$? \== 1），后面的命令就不会被执行。  
示例 1  
malihou@ubuntu:~\$ cp \~/Desktop/1.txt ~/1.txt \&\& rm \~/Desktop/1.txt \&\& echo "success"  
示例 1 中的命令首先从 \~\/Desktop 目录复制 1.txt 文件到 \~ 目录；执行成功后，使用 rm 删除源文件；如果删除成功则输出提示信息。  
\|\|运算符:  
command1 \|| command2  
\||则与\&&相反。如果\||左边的命令（命令1）未执行成功，那么就执行\||右边的命令（命令2）；或者换句话说，“如果这个命令执行失败了\||那么就执行这个命令。  
1 命令之间使用 \|| 连接，实现逻辑或的功能。  
2 只有在 || 左边的命令返回假（命令返回值 \$? \== 1），|| 右边的命令才会被执行。这和 c 语言中的逻辑或语法功能相同，即实现短路逻辑或操作。  
3 只要有一个命令返回真\（命令返回值 \$? \=\= 0），后面的命令就不会被执行。  
示例 2  
malihou@ubuntu:\~\$ rm \~/Desktop/1.txt \|\| echo "fail"  
在示例 2 中，如果 \~/Desktop 目录下不存在文件 1.txt，将输出提示信息。  
示例 3  
malihou@ubuntu\:\~\$ rm \~\/Desktop/1.txt \&\& echo "success" \|\| echo "fail"  
在示例 3 中，如果 \~\/Desktop 目录下存在文件 1.txt，将输出 success 提示信息；否则输出 fail 提示信息。

### 局部变量和全局变量
> 1. 全局变量 global variable
所谓全局变量，就是指变量在当前的整个 Shell 进程中都有效。每个 Shell 进程都有自己的作用域，彼此之间互不影响。在 Shell 中定义的变量，默认就是全局变量。
tips：大型脚本程序中函数中慎用全局变量
> 2. 局部变量 local variable
定义变量时，使用local关键字，只能在函数内部使用,函数执行完毕变量就会被销毁
函数内和外若存在同名变量，则函数内部变量覆盖函数外部变量,即只能在函数内使用
> 3. 环境变量 environment variable
全局变量只在当前 Shell 进程中有效，对其它 Shell 进程和子进程都无效。如果使用export命令将全局变量导出，那么它就在所有的子进程中也有效了，这称为“环境变量”。

环境变量被创建时所处的 Shell 进程称为父进程，如果在父进程中再创建一个新的进程来执行 Shell 命令，那么这个新的进程被称作 Shell 子进程。当 Shell 子进程产生时，它会继承父进程的环境变量为自己所用，所以说环境变量可从父进程传给子进程。不难理解，环境变量还可以传递给孙进程。

注意，两个没有父子关系的 Shell 进程是不能传递环境变量的，并且环境变量只能向下传递而不能向上传递，即“传子不传父”。

环境变量也是临时的
通过 export 导出的环境变量只对当前 Shell 进程以及所有的子进程有效，如果最顶层的父进程被关闭了，那么环境变量也就随之消失了，其它的进程也就无法使用了，所以说环境变量也是临时的。

如果我想让一个变量在所有 Shell 进程中都有效，不管它们之间是否存在父子关系，该怎么办呢？

只有将变量写入 Shell 配置文件中才能达到这个目的！Shell 进程每次启动时都会执行配置文件中的代码做一些初始化工作，如果将变量放在配置文件中，那么每次启动进程都会定义这个变量。



```
#!/bin/bash
var1="Hello World"

function test
{
    var2=2
    local var3=3
}
echo $var1
echo $var2
echo $var3

echo "*******"
test
echo $var2
echo $var3
```
> 运行结果
```
[Running] /bin/bash "/root/workspace/mooc/shell/var.sh"
Hello World


*******
2
```

### 函数库
#### 为什么要定义函数库
> 经常使用的重复代码封装成函数文件
一般不直接执行，而是由其他脚本调用

#### 经验
> 库文件名的后缀是任意的，但一般使用.lib
库文件通常没有可执行权限
库文件无需额脚本放在同级目录，只需要在脚本引用时指定，一般放在lib文件夹中
第一行一般使用#!/bin/echo,输出警告信息，避免用户执行，使用./执行时就会报警告信息中的错了
```
[root@manman lib]# ./base_function 
waring,this is afunction lib,can not be execute ./base_function
```


#### 如何引用函数库文件
> 在脚本中使用：
. + 函数库文件绝对路径，然后就可以在脚本中直接调用函数了
. /home/vagrant/shell/lib/base_function

#### 实例脚本
> 定义一个函数实现加、减、乘、除并可以显示系统、内存运行情况
```
#函数
#!/bin/echo waring,this is afunction lib,can not be execute
function add
{
    echo "`expr $1 + $2`"
}

function reduce
{
    echo "`expr $1 - $2`"
}

function multiple
{
    echo "`expr $1 \* $2`"
}

function divide
{
    echo "`expr $1 / $2`"
}

function sys_load
{
    echo "Memory Info"
    echo
    echo "`free -m`"
    echo
    echo "Disk Useage"
    echo `df -h`
}

#脚本
#!/bin/bash
. /root/workspace/mooc/shell/lib/base_function
echo "12+13=`add 12 13`"
echo ""
echo "15-2=`reduce 15 2`"
echo ""
echo "15*2=`multiple 15 2`"
echo ""
echo "13/2=`divide 13 2`"
echo ""
echo `sys_load`

```
***
## 常用工具
### 文件查找-find
#### 语法格式

|语法格式|find [路径] [选项] [操作]|
|:--:|:--:|

#### 常用参数
|选项|含义|
|:--:|:--:|
|-name|根据文件名查找|
|-iname|根据文件名查找,忽略大小写|
|-perm|根据文件权限查找|
|-prue|该选项可以排除某些查找目录，通常和-path一起使用，用于将特定目录排除在搜索条件之外|
|-user|根据文件属主查找|
|-group|根据文件属组查找|
|-mtime -n\|+n|根据文件更改时间查找。-n n天内，+n n天外修改的文件|
|-nogtroup|查找无有效属主的文件|
|-nouser|查找无有效属组的文件|
|-newer file1 !file2|查找更改时间比file1xin比file2旧的IDE文件|
|-type|按文件类型查找|
|-size -n +n|按文件大小查找|
|-mindepth n|从n级子目录开始搜索|
|-maxdepth n|最多搜索到n级子目录|

|文件类型|含义|
|:--:|:--:|
|f|文件|
|d|目录|
|c|字符设备文件|
|b|块设备文件|
|l|链接文件|
|p|管道文件|

#### 示例
>1. 查找/etc目录下5天内修改且以conf结尾的文件
find /etc -mime -5 -name '*.conf'
>2. 查找以mysql开头或history结尾的文件
find -name mysql* -o -name *history

#### 操作
|操作|含义|
|:--:|:--:|
|print|打印输出|
|exec|对搜索到的文件执行特定的操作，格式为-exec 'command' {} \;|
|-ok|和exec功能一样，只是每次操作都会给用户提示|

#### 示例
>1. 搜索/etc下的文件（非目录），文件名以conf结尾，且大于10k。然后将其删除
find ./etc/ -type f -name '*.conf' -size +10k -exec rm -rf {} \;
>find ./etc/ -type f -name '*.conf' -size +10k -exec cp {} /root/conf/ \;

#### 逻辑运算符
|选项|含义|
|:--:|:--:|
|-a|与（默认）|
|-o|或|
|not或!|非|

#### 示例
>1.查找当前目录下，属主不是hdfs的所有文件
find . -not -user hdfs |find . ! -user hdfs
>2. 查找当前目录下，属主是hdfs,且大小大于300字节的文件
find . -type f -a -user hdfs -a -size +300c 

### find、locate、whereis和which总结以及适用场景分析
#### locate
> 1. 文件查找命令，所属软件包mlocate
>2. 不同于find命令是在整块磁盘中搜索，locate命令是在数据库文件中查找
>3. find是默认全部匹配，locate则是默认部分匹配（包含就命中）
>4. updatedb命令
用户更新/var/lib/mlocate/mlocate.db
所使用配置文件/etc/updatedb.conf
该命令在后台cron计划任务中定期执行

#### whereis
|选项|含义|
|:--:|:--:|
|-b|只返回二进制文件|
|-m|只返回帮助文档文件|
|-s|只返回源代码文件|

#### which
作用：仅查找二进制程序文件

#### 各命令使用场景推荐
|命令|适用场景|优缺点|
|:--:|:--:|:--:|
|find|查找某一类文件，比如文件名部分一致|功能强大，速度慢|
|locate|只能查找单个文件|功能单一，速度快|
|whereis|查找程序可执行文件、帮助文档等|不常用|
|which|只查找程序可执行文件|常用于查找程序的绝对路径|

***
## 文本处理
### grep、egrep
#### grep语法格式
>两种形式
>1. grep [option] [pattern] [file1,file2...] 
>2. command | grep [option] [pattern]

#### 参数
|选项|含义|
|:--:|:--:|
|-v|不显示匹配行信息|
|-i|搜索时忽略大小写|
|-n|显示行号|
|-r|递归搜索，会进入当前路径下的目录中也进行查找|
|-E|支持扩展正则表达式|
|-F|不按正则表达式匹配。按照字符串意思匹配|
|-c|只显示匹配行总数|
|-w|匹配整词|
|-x|匹配整行|
|-l|只显示文件名，不显示内容|
|-s|不显示错误信息|

#### grep和egrep
>grep默认不支持扩展正则表达式，只支持基础正则表达式
使用grep -E可以支持扩展正则表达式
使用egrep可以支持扩展正则表达式，与grep -E等价

> 示例
过滤以#开头的行以及空白行
grep -v "^#" /etc/httpd/conf/httpd.conf |grep -v "^$"

### sed
#### 基础介绍
>sed(Stream Editor),流编辑器，对面准输出或文件逐行进行处理

#### 语法格式
>第一种形式： stdout | sed [option] "pattern command"  
第二种形式： sed [option] "pattern command" file

#### 参数
|选项|含义|
|:--:|:--:|
|-n|只打印模式匹配行|
|-e|直接在命令行进行sed编辑，默认选项|
|-f|编辑动作保存在文件中，指定文件执行|
|-r|支持扩展正则表达式|
|-i|直接修改文件内容|

|匹配模式|含义|
|:--:|:--:|
|10command|匹配到第十行|
|10，20command|匹配从第十行开始，到第二十行结束|
|10,+5command|匹配从第十行开始，到第十六行结束|
|/pattern1/command|匹配到pattern1的行|
|10,/pattern1/command|匹配从第十行开始，到匹配到pattern1的行结束|
|/pattern1/,10conmand|匹配到pattern1的行开始，到第十行结束|
|||

#### 编辑命令
|类别|编辑命令|含义|
|:--:|:--:|:--:|
|查询|p|打印|
|增加|a|行后追加|
|增加|i|行前追加|
|增加|r|外部文件读入，行后追加|
|增加|w|匹配行写入外部文件|
|删除|d|删除|
|修改|s/old/new|将行内第一个old替换为new|
|修改|s/old/new/g|将行内全部old替换为new|
|修改|s/old/new/g;p|将行内全部old替换为new，并打印|
|修改|s/old/new/2g|同一行内只将前两个old替换为new|
|修改|s/old/new/ig|将行内old全部替换为new，忽略大小写|
||=|显示匹配到的行号|


#### 示例
>1. -e
多次匹配，必须加上
>2. -f
[root@manman shell]# cat sed.txt 
I love python
I love PYTHON
Hadoop is bigdata frame
[root@manman shell]# cat sed.edit
/python/p
[root@manman shell]# sed -n -f sed.edit sed.txt 
I love python
>3. -e
[root@manman shell]# sed -n -e '/python/p' -e '/PYTHON/p' sed.txt 
I love python
I love PYTHON
>4. -r
[root@manman shell]# sed -n '/python|PYTHON/p' sed.txt
[root@manman shell]# sed -n -r '/python|PYTHON/p' sed.txt
I love python
I love PYTHON
>5. -i d
sed -i '/\/sbin\/nologin//d' passwd.txt
>5. sed -n "/^root/p file"
>7. a 
 sed '/\/bin\/bash/a This is user which can login to system' passwd 
>8. i
sed -i '/^root/,/^redis/i 123' passwd
在root开头至redis开头之间的行，每行前面增加123这一行
>9.  r
sed -i '/^root/r list' passwd
```
[root@manman shell]# sed -i '/^root/r list' passwd 
[root@manman shell]# cat list 
First Line(XXXXXX)
Second Line(YYYYYY)
[root@manman shell]# cat passwd 
root:x:0:0:root:/root:/bin/bash
First Line(XXXXXX)
Second Line(YYYYYY)
bin:x:1:1:bin:/bin:/sbin/nologin
```
>10. w
sed -n '/\/bin\/bash/w user_login.txt' passwd
[root@manman shell]# cat user_login.txt 
root:x:0:0:root:/root:/bin/bash

>11. =
sed -n '/\/sbin\/nologin/=' passwd
[root@manman shell]# sed -n '/\/sbin\/nologin/=' passwd
4
5
6

#### 反向引用(引用前面匹配到的内容)
|||
|:--:|:--:|
|&和\1（数字1）|引用模式匹配到的整个串|
|sed -i "s/l..e/&r/g" file|在file中搜寻以l开头，然后跟任意两个字符，以e结尾的字符串，在其尾部添加r|
|sed -i "/\\(l..e\\)/\1r/g" file | 和上面实现一样的功能，使用\1代表搜寻到的字符串，但是前面匹配的内容必须用括号括起来|

上面两种方式实现了一样的功能，分别使用&个\l引用前面匹配到的整个字符串
两者的区别在于&只能表示匹配到的完整字符串，只能引用整个字符串；而\1可以使用()对匹配到的字符串进一步拆分

例如：如果我们仅想要替换匹配到的字符串的一部分，name必须使用\l这种方式，不能使用&
```
[root@manman shell]# cat str.txt 
hadaaaaa is a big data frame
Spark hadbbbbb Kafka
Skill on hadccccc
Paper Of hadddddd
Google hadeeeee
[root@manman shell]# sed -i 's/\(had\)...../\1doop/g' str.txt 
[root@manman shell]# cat str.txt 
haddoop is a big data frame
Spark haddoop Kafka
Skill on haddoop
Paper Of haddoop
Google haddoop
```
#### sed中引用变量注意事项
>1. 匹配模式中存在变量，则建议使用双向引号
```
[root@manman shell]# cat str.txt 
hadoop is a big data frame
Spark hadoop Kafka
Skill on hadoop
Paper Of hadoop
Google hadoop
[root@manman shell]# cat example.sh 
#!/bin/bash
old_str=hadoop
new_str=HADOOP
sed -i 's/$old_str/$new_str/g' str.txt
[root@manman shell]# sh example.sh 
[root@manman shell]# cat str.txt 
hadoop is a big data frame
Spark hadoop Kafka
Skill on hadoop
Paper Of hadoop
Google hadoop
#修改单引号为双引号
[root@manman shell]# cat example.sh 
#!/bin/bash
old_str=hadoop
new_str=HADOOP
sed -i "s/$old_str/$new_str/g" str.txt
[root@manman shell]# sh example.sh 
[root@manman shell]# cat str.txt 
HADOOP is a big data frame
Spark HADOOP Kafka
Skill on HADOOP
Paper Of HADOOP
Google HADOOP

```
>2. sed中需要引入自定义变量时，如果外面使用单引号，则自定义变量也必须使用单引号
sed -i 's/'$old_str'/'$new_str'/g' str.txt

3. 如果需要匹配的包含了单引号，则必须外面使用双引号，这样才可以正确匹配到数据
[root@manman shell]# sed -n '/'6000'/p' 1.txt 
'6000'
6000
[root@manman shell]# sed -n "/'6000'/p" 1.txt 
'6000'
[root@manman shell]# vim 1.txt
[root@manman shell]# cat 1.txt
'6000'
'500'
6000

#### 利用sed查找文件内容
>1. 打印/etc/passwd中第二十行的内容
sed -n '20p' /etc/passwd
>2. 打印/etc/passwd中第8行开始，第事务航结束的内容
sed -n '8,15p' /etc/passwd
>3. 打印/etc/passwd中第8行开始，然后+5行结束的内容
sed -n '8,+5p' /etc/passwd
>4. 打印/etc/passwd中开头匹配hdfs字符串的内容
sed -n '/^hdfs/p' /etc/passwd
>5. 打印/etc/passwd中开头为root的行开始，到开头为hdfs的行结束的内容
sed -n '/^root/,/hdfs/p' /etc/passwd
>6. 打印/etc/passwd中第8行开始，到含有/sbin/nologin的内容行结束
sed -n '8,/\/sbin\/nologin/p' /etc/passwd
>7. 打印/etc/passwd中第1个包含/bin/bash内容的行开始，到第5行结束的内容
sed -n '/\\/bin\\/bash/,5p' /etc/passwd

#### 脚本示例
>1. 需求描述：处理一个类似mysql的配置文件my.cnf文本，示例如下；
编写脚本实现以下功能：输出文件有几个段，并且针对每个段可以统计配置参数总个数
预想输出结果：
1：client 2
2：server 12
3：mysqld 12
4：mysqld_safe 7
5：embedded 8
6：mysqld-5.5 9

函数
1. function get_all_segment
统计一共有多少个段
2. function count_items_in_segment
统计段中的配置项个数




>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>

## 循环控制
和其它编程语言类似，Shell 也支持选择结构，并且有两种形式，分别是 if else 语句和 case in 语句。本节我们先介绍 if else 语句，case in 语句将会在《Shell case in》中介绍。
如果你已经熟悉了C语言、Java、JavaScript 等其它编程语言，那么你可能会觉得 Shell 中的 if else 语句有点奇怪。
### if
最简单的用法就是只使用 if 语句，它的语法格式为：
```
if  condition
then
    statement(s)
fi
```
condition是判断条件，如果 condition 成立（返回“真”），那么 then 后边的语句将会被执行；如果 condition 不成立（返回“假”），那么不会执行任何语句。
从本质上讲，if 检测的是命令的退出状态
注意，最后必须以fi来闭合，fi 就是 if 倒过来拼写。也正是有了 fi 来结尾，所以即使有多条语句也不需要用{ }包围起来。
如果你喜欢，也可以将 then 和 if 写在一行：
```
if  condition;  then
    statement(s)
fi
```
请注意 condition 后边的分号;，当 if 和 then 位于同一行的时候，这个分号是必须的，否则会有语法错误。


实例1
下面的例子使用 if 语句来比较两个数字的大小：
```
#!/bin/bash
read a
read b
if (( $a == $b ))
then
    echo "a和b相等"
fi
```
(())是一种数学计算命令，它除了可以进行最基本的加减乘除运算，还可以进行大于、小于、等于等关系运算，以及与、或、非逻辑运算。当 a 和 b 相等时，(( $a == $b ))判断条件成立，进入 if，执行 then 后边的 echo 语句。

实例2
在判断条件中也可以使用逻辑运算符，例如：
```
#!/bin/bash
read age
read iq
if (( $age > 18 && $iq < 60 ))
then
    echo "你都成年了，智商怎么还不及格！"
fi
```
&&就是逻辑“与”运算符，只有当&&两侧的判断条件都为“真”时，整个判断条件才为“真”。
熟悉其他编程语言的读者请注意，即使 then 后边有多条语句，也不需要用{ }包围起来，因为有 fi 收尾

### if else 语句
如果有两个分支，就可以使用 if else 语句，它的格式为：
```
if  condition
then
   statement1
else
   statement2
fi
```
如果 condition 成立，那么 then 后边的 statement1 语句将会被执行；否则，执行 else 后边的 statement2 语句。
```
#!/bin/bash
read a
read b
if (( $a == $b ))
then
    echo "a和b相等"
else
    echo "a和b不相等，输入错误"
fi
```

### if elif else 语句
Shell 支持任意数目的分支，当分支比较多时，可以使用 if elif else 结构，它的格式为：
```
if  condition1
then
   statement1
elif condition2
then
    statement2
elif condition3
then
    statement3
……
else
   statementn
fi
```
注意，if 和 elif 后边都得跟着 then。
整条语句的执行逻辑为：
如果 condition1 成立，那么就执行 if 后边的 statement1；如果 condition1 不成立，那么继续执行 elif，判断 condition2。
如果 condition2 成立，那么就执行 statement2；如果 condition2 不成立，那么继续执行后边的 elif，判断 condition3。
如果 condition3 成立，那么就执行 statement3；如果 condition3 不成立，那么继续执行后边的 elif。
如果所有的 if 和 elif 判断都不成立，就进入最后的 else，执行 statementn。
```
#!/bin/bash
read age
if (( $age <= 2 )); then
    echo "婴儿"
elif (( $age >= 3 && $age <= 8 )); then
    echo "幼儿"
elif (( $age >= 9 && $age <= 17 )); then
    echo "少年"
elif (( $age >= 18 && $age <=25 )); then
    echo "成年"
elif (( $age >= 26 && $age <= 40 )); then
    echo "青年"
elif (( $age >= 41 && $age <= 60 )); then
    echo "中年"
else
    echo "老年"
fi
```

### 退出状态
#### 概述
每一条 Shell 命令，不管是 Bash 内置命令（例如 cd、echo），还是外部的 Linux 命令（例如 ls、awk），还是自定义的 Shell 函数，当它退出（运行结束）时，都会返回一个比较小的整数值给调用（使用）它的程序，这就是命令的退出状态（exit statu）。
>很多 Linux 命令其实就是一个C语言程序，熟悉C语言的读者都知道，main() 函数的最后都有一个return 0，如果程序想在中间退出，还可以使用exit 0，这其实就是C语言程序的退出状态。当有其它程序调用这个程序时，就可以捕获这个退出状态。
if 语句的判断条件，从本质上讲，判断的就是命令的退出状态。

按照惯例来说，退出状态为 0 表示“成功”；也就是说，程序执行完成并且没有遇到任何问题。除 0 以外的其它任何退出状态都为“失败”。

之所以说这是“惯例”而非“规定”，是因为也会有例外，比如 diff 命令用来比较两个文件的不同，对于“没有差别”的文件返回 0，对于“找到差别”的文件返回 1，对无效文件名返回 2。
有编程经验的读者请注意，Shell 的这个部分与你所熟悉的其它编程语言正好相反：在C语言、C++、Java、Python 中，0 表示“假”，其它值表示“真”。
在 Shell 中，有多种方式取得命令的退出状态，其中 $? 是最常见的一种。

#### 退出状态和逻辑运算符的组合
Shell if 语句的一个神奇之处是允许我们使用逻辑运算符将多个退出状态组合起来，这样就可以一次判断多个条件了。


|运算符|使用格式|说明|
|:--:|:--:|:--:|
|&&|expression1 && expression2|逻辑与运算符，当 expression1 和 expression2 同时成立时，整个表达式才成立。如果检测到 expression1 的退出状态为 0，就不会再检测 expression2 了，因为不管 expression2 的退出状态是什么，整个表达式必然都是不成立的，检测了也是多此一举。|
|\|\||expression1 \|\| expression2|逻辑或运算符，expression1 和 expression2 两个表达式中只要有一个成立，整个表达式就成立。如果检测到 expression1 的退出状态为 1，就不会再检测 expression2 了，因为不管 expression2 的退出状态是什么，整个表达式必然都是成立的，检测了也是多此一举。|
|!|!expression|逻辑非运算符，相当于“取反”的效果。如果 expression 成立，那么整个表达式就不成立；如果 expression 不成立，那么整个表达式就成立。|

```
#将用户输入的 URL 写入到文件中。
纯文本复制
#!/bin/bash
read filename
read url
if test -w $filename && test -n $url
then
    echo $url > $filename
    echo "写入成功"
else
    echo "写入失败"
fi
```
在 Shell 脚本文件所在的目录新建一个文本文件并命名为 urls.txt，然后运行 Shell 脚本，运行结果为：
urls.txt↙
http://c.biancheng.net/shell/↙
写入成功

test 是 Shell 内置命令，可以对文件或者字符串进行检测，其中，-w选项用来检测文件是否存在并且可写，-n选项用来检测字符串是否非空。

\>表示重定向，默认情况下，echo 向控制台输出，这里我们将输出结果重定向到文件。

### test([])命令
test 是 Shell 内置命令，用来检测某个条件是否成立。test 通常和 if 语句一起使用，并且大部分 if 语句都依赖 test。

test 命令有很多选项，可以进行数值、字符串和文件三个方面的检测。

Shell test 命令的用法为：
```
test expression
```
当 test 判断 expression 成立时，退出状态为 0，否则为非 0 值。
test 命令也可以简写为[]，它的用法为：
```
[ expression ]
```
注意[]和expression之间的空格，这两个空格是必须的，否则会导致语法错误。[]的写法更加简洁，比 test 使用频率高。

#### 与文件检测相关的 test 选项
文件类型判断
|选项|作用|
|:--:|:--:|
|-b file|判断文件是否存在，并且是否为块文件|
|-c file|判断文件是否存在，并且是否为字符设备文件|
|-d file|判断文件是否存在，并且是否为目录文件|
|-e file|判断文件是否存在|
|-f file|判断文件是否存在，并且是否为普通文件|
|-L file|判断文件是否存在，并且是否为符号链接文件|
|-p file|判断文件是否存在，并且是否为管道文件|
|-s file|判断文件是否存在，并且是否为非空|
|-S file|判断文件是否存在，并且是否为套接字文件|

文件权限判断
|选项|作用|
|:--:|:--:|
|-r file|判断文件是否存在，并且是否拥有读权限|
|-w file|判断文件是否存在，并且是否拥有写权限|
|-x file|判断文件是否存在，并且是否拥有执行权限|
|-u file|判断文件是否存在，并且是否拥有SGID权限|
|-g file|判断文件是否存在，并且是否拥有SGID权限|
|-k file|判断文件是否存在，并且是否拥有SBIT权限|

文件比较
|选项|作用|
|:--:|:--:|
|file1 -nt file2|判断file1的修改时间是否比file2新|
|file1 -ot file2|判断file1的修改时间是否比file2旧|
|file1 ef file2|判断file1是否和file2的inode号一致，可以理解为两个文件是否为同一文件。这个判断用于硬链接是很好的办法|
|||
|||

#### 与数值比较相关的 test 选​项
|选项|作用|
|:--:|:--:|
|-eq|相等|
|-ne|不相等|
|-gt|大于|
|-lt|小于|
|-ge|大于等于|
|le|小于等于|

注意，test 只能用来比较整数，小数相关的比较还得依赖 bc 命令。

####  与字符串判断相关的 test 选项
|选项|作用|
|:--:|:--:|
|-z str|判断字符串str是否为空|
|-n str|判断自串串str是否为非空|
|str1 = str2或str1 == str2|=和==是等价的，都是用来判断str1和str2是否相等|
|str1 = str2|判断str1是否和str2不相等|
|str1 \> str2|判断str1是否大于str2 \\>是>的转义字符，这样写是为了防止>被误认为重定向运算符|
|str1 \< str2|判断str1是否小于str2|

有C语言、C++、Python、Java 等编程经验后需要注意，==、>、< 在大部分编程语言中都用来比较数字，而在 Shell 中，它们只能用来比较字符串，不能比较数字

其次，不管是比较数字还是字符串，Shell 都不支持 >= 和 <= 运算符，切记。

```
#!/bin/bash
read str1
read str2
#检测字符串是否为空
if [ -z "$str1" ] || [ -z "$str2" ]
then
    echo "字符串不能为空"
    exit 0
fi
#比较字符串
if [ $str1 = $str2 ]
then
    echo "两个字符串相等"
else
    echo "两个字符串不相等"
fi
```

####  与逻辑运算相关的 test 选项
|选项|作用|
|:--:|:--:|
|expression1 -a expression|	逻辑与，表达式 expression1 和 expression2 都成立，最终的结果才是成立的。|
|expression1 -o expression2|	逻辑或，表达式 expression1 和 expression2 有一个成立，最终的结果就成立。|
|!expression	|逻辑非，对 expression 进行取反。|

```
#!/bin/bash
read str1
read str2
#检测字符串是否为空
if [ -z "$str1" -o -z "$str2" ]  #使用 -o 选项取代之前的 ||
then
    echo "字符串不能为空"
    exit 0
fi
#比较字符串
if [ $str1 = $str2 ]
then
    echo "两个字符串相等"
else
    echo "两个字符串不相等"
fi
```
前面的代码我们使用两个[]命令，并使用||运算符将它们连接起来，这里我们改成-o选项，只使用一个[]命令就可以了。

#### 注意事项
在 test 中使用变量建议用双引号包围起来
test 和 [] 都是命令，一个命令本质上对应一个程序或者一个函数。即使是一个程序，它也有入口函数，例如C语言程序的入口函数是 main()，运行C语言程序就从 main() 函数开始，所以也可以将一个程序等效为一个函数，这样我们就不用再区分函数和程序了，直接将一个命令和一个函数对应起来即可。

有了以上认知，就很容易看透命令的本质了：使用一个命令其实就是调用一个函数，命令后面附带的选项和参数最终都会作为实参传递给函数。

假设 test 命令对应的函数是 func()，使用test -z \$str1命令时，会先将变量 \$str1 替换成字符串：
如果 \$str1 是一个正常的字符串，比如 abc123，那么替换后的效果就是test -z abc123，调用 func() 函数的形式就是func("-z abc123")。test 命令后面附带的所有选项和参数会被看成一个整体，并作为实参传递进函数。
如果 \$str1 是一个空字符串，那么替换后的效果就是test -z，调用 func() 函数的形式就是func("-z ")，这就比较奇怪了，因为-z选项没有和参数成对出现，func() 在分析时就会出错。

如果我们给 \$str1 变量加上双引号，当 \$str1 是空字符串时，test -z "\$str1"就会被替换为test -z ""，调用 func() 函数的形式就是func("-z \\"\\"")，很显然，-z选项后面跟的是一个空字符串（\"表示转义字符），这样 func() 在分析时就不会出错了。

所以，当你在 test 命令中使用变量时，我强烈建议将变量用双引号""包围起来，这样能避免变量为空值时导致的很多奇葩问题。

#### 总结
test 命令比较奇葩，>、<、== 只能用来比较字符串，不能用来比较数字，比较数字需要使用 -eq、-gt 等选项；不管是比较字符串还是数字，test 都不支持 >= 和 <=。有经验的程序员需要慢慢习惯 test 命令的这些奇葩用法。

对于整型数字的比较，我建议大家使用 (())，这在《Shell if else》中已经进行了演示。(()) 支持各种运算符，写法也符合数学规则，用起来更加方便，何乐而不为呢？

几乎完全兼容 test ，并且比 test 更加强大，比 test 更加灵活的是[[ ]]；[[ ]]不是命令，而是 Shell 关键字

### [[]]
[[ ]]是 Shell 内置关键字，它和 test 命令类似，也用来检测某个条件是否成立。

test 能做到的，[[ ]] 也能做到，而且 [[ ]] 做的更好；test 做不到的，[[ ]] 还能做到。可以认为 [[ ]] 是 test 的升级版，对细节进行了优化，并且扩展了一些功能。

[[ ]] 的用法为：
```
[[ expression ]]
```
当 [[ ]] 判断 expression 成立时，退出状态为 0，否则为非 0 值。注意[[ ]]和expression之间的空格，这两个空格是必须的，否则会导致语法错误。

#### [[]]不需要注意某些细枝末节
[[]]是 Shell 内置关键字，不是命令，在使用时没有给函数传递参数的过程，所以 test 命令的某些注意事项在 [[ ]] 中就不存在了，具体包括：
1. 不需要把变量名用双引号""包围起来，即使变量是空值，也不会出错。
2. 不需要、也不能对 >、< 进行转义，转义后会出错。

```
#!/bin/bash
read str1
read str2
if [[ -z $str1 ]] || [[ -z $str2 ]]  #不需要对变量名加双引号
then
    echo "字符串不能为空"
elif [[ $str1 < $str2 ]]  #不需要也不能对 < 进行转义
then
    echo "str1 < str2"
else
    echo "str1 >= str2"
fi
```

####　支持逻辑运算符
对多个表达式进行逻辑运算时，可以使用逻辑运算符将多个 test 命令连接起来，例如：
```
[ -z "\$str1" ] || [ -z "\$str2" ]
```
也可以借助选项把多个表达式写在一个 test 命令中，例如：
[ -z "\$str1" -o -z "\$str2" ]

但是，这两种写法都有点“别扭”，完美的写法是在一个命令中使用逻辑运算符将多个表达式连接起来。我们的这个愿望在 [[ ]] 中实现了，[[ ]]  支持 &&、|| 和 ! 三种逻辑运算符。

使用 [[ ]] 对上面的语句进行改进：
```
[[ -z $str1 || -z $str2 ]]
```
注意，[[ ]] 剔除了 test 命令的-o和-a选项，你只能使用 || 和 &&。这意味着，你不能写成下面的形式：
```
[[ -z $str1 -o -z $str2 ]]
```
当然，使用逻辑运算符将多个 [[ ]] 连接起来依然是可以的，因为这是 Shell 本身提供的功能，跟 [[ ]] 或者 test 没有关系，如下所示：
```
[[ -z $str1 ]] || [[ -z $str2 ]]
```

如下总结了各种写法的对错
test 或 []
正确
[ -z "\$str1" ] || [ -z "\$str2" ]	
[ -z "\$str1" -o -z "\$str2" ]
错误
\[\[ -z \$str1 \|\| -z \$str2 ]]

\[\[ ]]
正确
\[\[ -z \$str1 ]] || \[\[ -z \$str2 ]]
\[\[ -z \$str1 || -z \$str2 ]]
错误
\[\[ -z \$str1 -o -z \$str2 ]]

####　[[]]支持正则表达式
在 Shell [[ ]] 中，可以使用=~来检测字符串是否符合某个正则表达式，它的用法为：
```
[[ str =~ regex ]]
```
str 表示字符串，regex 表示正则表达式。

下面的代码检测一个字符串是否是手机号：
```
#!/bin/bash
read tel
if [[ $tel =~ ^1[0-9]{10}$ ]]
then
    echo "你输入的是手机号码"
else
    echo "你输入的不是手机号码"
fi
```

### case in语句详解
和其它编程语言类似，Shell 也支持两种分支结构（选择结构），分别是 if else 语句和 case in 语句。
当分支较多，并且判断条件比较简单时，使用 case in 语句就比较方便了。
#### 基本格式：
```
case expression in
    pattern1)
        statement1
        ;;
    pattern2)
        statement2
        ;;
    pattern3)
        statement3
        ;;
    ……
    *)
        statementn
esac
```
case、in 和 esac 都是 Shell 关键字，expression 表示表达式，pattern 表示匹配模式。
expression 既可以是一个变量、一个数字、一个字符串，还可以是一个数学计算表达式，或者是命令的执行结果，只要能够得到 expression 的值就可以。
pattern 可以是一个数字、一个字符串，甚至是一个简单的正则表达式。

case 会将 expression  的值与 pattern1、pattern2、pattern3 逐个进行匹配：
如果 expression 和某个模式（比如 pattern2）匹配成功，就会执行这模式（比如 pattern2）后面对应的所有语句（该语句可以有一条，也可以有多条），直到遇见双分号;;才停止；然后整个 case 语句就执行完了，程序会跳出整个 case 语句，执行 esac 后面的其它语句。
如果 expression 没有匹配到任何一个模式，那么就执行*)后面的语句（\*表示其它所有值），直到遇见双分号;;或者esac才结束。\*)相当于多个 if 分支语句中最后的 else 部分。
如果你有C语言、C++、Java 等编程经验，这里的;;和*)就相当于其它编程语言中的 break 和 default。


#### 对\*)的几点说明：
Shell case in 语句中的\*)用来“托底”，万一 expression 没有匹配到任何一个模式，\*)部分可以做一些“善后”工作，或者给用户一些提示。
可以没有\*)部分。如果 expression 没有匹配到任何一个模式，那么就不执行任何操作。

除最后一个分支外（这个分支可以是普通分支，也可以是*)分支），其它的每个分支都必须以;;结尾，;;代表一个分支的结束，不写的话会有语法错误。最后一个分支可以写;;，也可以不写，因为无论如何，执行到 esac 都会结束整个 case in 语句。

上面的代码是 case in 最常见的用法，即 expression 部分是一个变量，pattern 部分是一个数字或者表达式。

#### case in 和正则表达式
case in 的 pattern 部分支持简单的正则表达式，具体来说，可以使用以下几种格式：
|格式|说明|
|:--:|:--:|
|*|表示任意字符串|
|[abc]|表示 a、b、c 三个字符中的任意一个。比如，[15ZH] 表示 1、5、Z、H 四个字符中的任意一个。|
|[m-n]|表示从 m 到 n 的任意一个字符。比如，[0-9] 表示任意一个数字，[0-9a-zA-Z] 表示字母或数字|
|\||表示多重选择，类似逻辑运算中的或运算。比如，abc | xyz 表示匹配字符串 "abc" 或者 "xyz"。|
如果不加以说明，Shell 的值都是字符串，expression 和 pattern 也是按照字符串的方式来匹配的；本节第一段代码看起来是判断数字是否相等，其实是判断字符串是否相等。

最后一个分支*)并不是什么语法规定，它只是一个正则表达式，*表示任意字符串，所以不管 expression 的值是什么，*)总能匹配成功。
```
#!/bin/bash
printf "Input a character: "
read -n 1 char
case $char in
    [a-zA-Z])
        printf "\nletter\n"
        ;;
    [0-9])
        printf "\nDigit\n"
        ;;
    [0-9])
        printf "\nDigit\n"
        ;;
    [,.?!])
        printf "\nPunctuation\n"
        ;;
    *)
        printf "\nerror\n"
esac
```

### while循环详解
while 循环是 Shell 脚本中最简单的一种循环，当条件满足时，while 重复地执行一组语句，当条件不满足时，就退出 while 循环。
#### 语法
```
while condition
do
    statements
done
```
condition表示判断条件，statements表示要执行的语句（可以只有一条，也可以有多条），do和done都是 Shell 中的关键字。

while 循环的执行流程为：
先对 condition 进行判断，如果该条件成立，就进入循环，执行 while 循环体中的语句，也就是 do 和 done 之间的语句。这样就完成了一次循环。
每一次执行到 done 的时候都会重新判断 condition 是否成立，如果成立，就进入下一次循环，继续执行 do 和 done 之间的语句，如果不成立，就结束整个 while 循环，执行 done 后面的其它 Shell 代码。
如果一开始 condition 就不成立，那么程序就不会进入循环体，do 和 done 之间的语句就没有执行的机会。

注意，在 while 循环体中必须有相应的语句使得 condition 越来越趋近于“不成立”，只有这样才能最终退出循环，否则 while 就成了死循环，会一直执行下去，永无休止。

while 语句和 if else 语句中的 condition 用法都是一样的，你可以使用 test 或 [] 命令，也可以使用 (()) 或 [[]]


```
#【实例1】计算从 1 加到 100 的和。
纯文本复制
#!/bin/bash
i=1
sum=0
while ((i <= 100))
do
    ((sum += i))
    ((i++))
done
echo "The sum is: $sum"

#【实例2】计算从 m 加到 n 的值。
纯文本复制
#!/bin/bash
read m
read n
sum=0
while ((m <= n))
do
    ((sum += m))
    ((m++))
done
echo "The sum is: $sum"

```

### until
unti 循环和 while 循环恰好相反，当判断条件不成立时才进行循环，一旦判断条件成立，就终止循环。

until 的使用场景很少，一般使用 while 即可。

#### 语法
```
until condition
do
    statements
done
```
condition表示判断条件，statements表示要执行的语句（可以只有一条，也可以有多条），do和done都是 Shell 中的关键字。

until 循环的执行流程为：
先对 condition 进行判断，如果该条件不成立，就进入循环，执行 until 循环体中的语句（do 和 done 之间的语句），这样就完成了一次循环。
每一次执行到 done 的时候都会重新判断 condition 是否成立，如果不成立，就进入下一次循环，继续执行循环体中的语句，如果成立，就结束整个 until 循环，执行 done 后面的其它 Shell 代码。
如果一开始 condition 就成立，那么程序就不会进入循环体，do 和 done 之间的语句就没有执行的机会。

注意，在 until 循环体中必须有相应的语句使得 condition 越来越趋近于“成立”，只有这样才能最终退出循环，否则 until 就成了死循环，会一直执行下去，永无休止。

```
#!/bin/bash
i=1
sum=0
until ((i > 100))
do
    ((sum += i))
    ((i++))
done
echo "The sum is: $sum"
```

### for
#### c语言风格for循环
#### 语法
```
for((exp1; exp2; exp3))
do
    statements
done
```
几点说明：
exp1、exp2、exp3 是三个表达式，其中 exp2 是判断条件，for 循环根据 exp2 的结果来决定是否继续下一次循环；
statements 是循环体语句，可以有一条，也可以有多条；
do 和 done 是 Shell 中的关键字。

#### 运行过程
1\) 先执行 exp1。

2\) 再执行 exp2，如果它的判断结果是成立的，则执行循环体中的语句，否则结束整个 for 循环。

3\) 执行完循环体后再执行 exp3。

4\) 重复执行步骤 2) 和 3)，直到 exp2 的判断结果不成立，就结束循环。

上面的步骤中，2) 和 3) 合并在一起算作一次循环，会重复执行，for 语句的主要作用就是不断执行步骤 2) 和 3)。

exp1 仅在第一次循环时执行，以后都不会再执行，可以认为这是一个初始化语句。exp2 一般是一个关系表达式，决定了是否还要继续下次循环，称为“循环条件”。exp3 很多情况下是一个带有自增或自减运算的表达式，以使循环条件逐渐变得“不成立”。

for 循环的执行过程可用下图表示：
![](http://guanxiaoman.cn-sh2.ufileos.com/Shell%2Fshell-1.png)

```
#1加到100的和
#!/bin/bash
sum=0
for ((i=1; i<=100; i++))
do
    ((sum += i))
done
echo "The sum is: $sum"
```

代码分析：
1) 执行到 for 语句时，先给变量 i 赋值为 1，然后判断 i<=100 是否成立；因为此时 i=1，所以 i<=100 成立。接下来会执行循环体中的语句，等循环体执行结束后（sum 的值为1），再计算 i++。

2) 第二次循环时，i 的值为2，i<=100 成立，继续执行循环体。循环体执行结束后（sum的值为3），再计算 i++。

3) 重复执行步骤 2)，直到第 101 次循环，此时 i 的值为 101，i<=100 不再成立，所以结束循环。

由此我们可以总结出 for 循环的一般形式为：
```
for(( 初始化语句; 判断条件; 自增或自减 ))
do
    statements
done
```
#### for循环中的三个表达式
for 循环中的 exp1（初始化语句）、exp2（判断条件）和 exp3（自增或自减）都是可选项，都可以省略（但分号;必须保留）。








































## expect





















