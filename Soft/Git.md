# Git
## 什么是git
> 是一个开源的分布式版本控制系统
可以有效、高速地处理从很小到非常大的项目版本管理
![](http://guanxiaoman.cn-sh2.ufileos.com/Git%2Fgit-1.png)

## 下载与安装
> 官网地址 git-scm.com
安装过程中注意勾选 "Use Git and optional Unix tools from the Command Prompt"。
vscode后续通过romote ssh链接远程主机需要该选项
![](http://guanxiaoman.cn-sh2.ufileos.com/Git%2Fgit-2.png)

## 基本操作
>1. 配置用户名和邮箱  
git config --global user.name 'ddvi'  
git config --global user.email 'lgr19710903@gmail.com'
>2. 使用git clone远程仓库  
 git clone https://github.com/ddvi/vscode.git
>3. 进入工作目录
cd vscode
>4. 添加
git add index.html
>5. 提交
git commit -m '提交信息，修改了哪些内容'   也可提交单个文件
>6.推送
git push
>7. 输入github用户名密码
>8. 拉取
git pull 
>9. 检出分支或找回在工作区删除的文件
git checkout index.html
