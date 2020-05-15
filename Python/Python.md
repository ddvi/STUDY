<!-- TOC -->

- [Python](#python)
    - [第一章 前言](#第一章-前言)
        - [1-1 导学](#1-1-导学)
            - [一、基础语法](#一基础语法)
            - [二、](#二)
            - [三、语法特点](#三语法特点)
            - [四、Python可以做些什么？](#四python可以做些什么)
            - [五、Python之禅](#五python之禅)
        - [1-2 Python特点](#1-2-python特点)
        - [1-3 Python的缺点](#1-3-python的缺点)
        - [1-4 一个经典误区](#1-4-一个经典误区)
        - [1-5 Python能做些什么](#1-5-python能做些什么)
        - [1-6 课程内容与特点](#1-6-课程内容与特点)
    - [第二章 Python环境安装](#第二章-python环境安装)
        - [2-1 下载安装Python](#2-1-下载安装python)
        - [2-2 IDLE与第一段Python代码](#2-2-idle与第一段python代码)
    - [第三章 Python基本类型](#第三章-python基本类型)
        - [3-1 基本数据类型](#3-1-基本数据类型)

<!-- /TOC -->

# Python
## 第一章 前言
### 1-1 导学
#### 一、基础语法
1.从最基本的变量到复杂的高阶函数。
2.了解语法是编程的先决条件。
3.精通语法是编好程的必要条件。
#### 二、
1.面向对象（OOP）
2.Object Oriented Programming；面向对象编程。
3.Object-oriented thinking；面向对象思想。
4.Python思想之一：“一切皆对象”。
5.Life is Simple,I Use Python;人生苦短，我用Python
6.Pythonic;很 & Python
####  三、语法特点
1.简洁
>其他语言交换变量：
temp=x
x=y
y=temp
而Python：
x,y=y,x

2.Python非常易于学习
#### 四、Python可以做些什么？
1.爬虫（reptile）
2.大数据（Big Data）
3.测试（test）
4.Web
5.AI(Artificial Intelligence)
6.脚本处理（Script processing）
#### 五、Python之禅
简介，灵活，优雅，哲学
1.Simple is better than complex
简洁胜于复杂
2.Now is better than never. Although never is often better than \*right\* now
做也许好过不做，但不假思索就动手还不如不做
3.易于上手有，难于精通
4.既有动态脚本的特性，又有面向对象的特性
### 1-2 Python特点
1. 一种编程语言，不是框架也不是类库
（框架是以语言为基础，构建的一系列基础功能的集合）
2. 语法简单,优雅,编写的程序易于阅读
life is short i love python  人生苦短，我用python
3. 跨平台：Windows、Linux、MacOS
4. 易学习：语法可阅读性强、高度抽象化（Python动态语言
语言）
5. 库资源极为强大且丰富
6. 面向对象（编程思想，面向对象是一种思想，把现实世界
系映射到计算机语言中去）
 把面向对象的概念理解为代码的组织和构建的方式，易于读取和管理
 持续不断理解的过程
### 1-3 Python的缺点
慢（相较于C、C++、Java，运行效率慢，但也不是特别慢，
到）
1.编译型语言（执行前先编译，编译成机器码，贴近机器，
底层开发）：c，c++
2.解释型语言（不编译，直接执行，适合上层开发）：pyth
ipt
java，c#有编译，但不编译成机器码，算是一种中间语言
运行效率和开发效率，鱼和熊掌不可兼得
适合的才是最好的
重点是编程功底
### 1-4 一个经典误区
世界不是只有Web，还有很多问题需要使用编程来解决。
不要把思维局限在Web上，这只是编程的一个应用方向。
Python 应用方向非常广泛。前端，后台，小程序，人工智能
习，大数据等无所不能
编程是解决问题的工具，它有很多方面的应用。
### 1-5 Python能做些什么
1.爬虫->搜索引擎，今日头条；
2.大数据与数据分析(Spark): python 是spark支持的语言之
3.自动化运维与自动化测试；
4.web 开发： Flask, Django框架;
5.机器学习： Tensor Flow框架 google的;
6.胶水语言：混合C++,java等来编程。能够把其他语言制作
(C/C++)很轻松的联结在一起。

### 1-6 课程内容与特点
1、基础语法
基础语法是任何语言的基础，只有熟练掌握，才能灵活运用
高效、优美、简洁的代码.
Python的语法是非常灵活的又别具一格的。学习语言就要学
格、特点，这才是语言的精辟。Python尤其如此
2、Pythonic
将a、b两个变量的值交换 a,b=b,a
3、Python高性能与优化
同样的一个功能，可能有数个乃至十种写法，但每种写法的
度是不同的。选择性能最高又易于理解的写法才是正确的
4、数据结构
尝试用Python来实现一些常见的数据结构，什么是扎实的编
据结构才是基础。

>书籍推荐
《流畅的python》
习题练习
搜索python oj
>web框架  Django Flask



## 第二章 Python环境安装 
### 2-1 下载安装Python
https://www.python.org/downloads/release/python-381/
### 2-2 IDLE与第一段Python代码
```
Python 3.8.1 (tags/v3.8.1:1b293b6, Dec 18 2019, 22:39:24) [MSC v.1916 32 bit (Intel)] on win32
Type "help", "copyright", "credits" or "license()" for more information.
>>> print('hellw world');
hellw world
```
>什么是代码？
>代码是现实世界事物在计算机世界中的映射
>什么是写代码？
>写代码是将现实世界中的事物用计算机语言来描述
## 第三章 Python基本类型
### 3-1 基本数据类型
Number：数字
    整数：int
        其他语言：short、int、long
    浮点数：float
        其他语言：单精度（float）,双精度（double）
        python中只有float
```
#
>>> type(1)
<class 'int'>
>>> type(-1)
<class 'int'>
>>> type(1.1)
<class 'float'>
>>> type(1.11111111)
<class 'float'>
```