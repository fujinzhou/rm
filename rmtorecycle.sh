#!/bin/bash 
#Author:ymc023
#Mail:ymc023@163.com 
#Platform:Centos7,debian8
#Date:2017年02月16日 星期四 10时36分

#运行脚本将下面的内容追加到~/.bashrc
#运行完脚本请source ~/.bashrc
#脚本会在当前用户家目录下创建.recycle
#重名文件会提示覆盖，但会备份，备份格式:*.~*~

#使用rm删除文件会使用mv移动至~/.recycle
#使用rmls查看回收筒内的文件
#使用undorm * 恢复被删除的文件到当前路径下
#使用cltrash清除~/.recycle下的全部文件

cat >> ~/.bashrc <<EOF
#start
#从这儿开始是用mv替换rm的代码段

#别名
alias rm='rmtorecycle'
alias rmls='recyclelist'
alias undorm='undormtorecycle'
alias cltrash='clearrecycle'


#mkdir .recycle

mkrecycle()
{
   if [ ! -d ~/.recycle/  ];then
   mkdir ~/.recycle
   fi
}
mkrecycle
TRASH=~/.recycle/
whoami=`whoami`
#定义禁止删除根目录
rmdir='/'
#移动文件至.recycle
rmtorecycle()
{
    if [ "$1" = "" ];then
    echo "Usage:rm <filename>"
    elif [ "$1" = $rmdir ];then
    echo "禁止删除根操作!已经邮件通知给系统管理员"
    echo $whoami 在执行删除根的操作，请悉知 | mail -s "warning" 1445675350@qq.com
    else
    mv -f $1 $TRASH --backup=numbered -fi
    echo $1 已经被删除 | mail -s "warning" 1445675350@qq.com
    echo $1 已经被删除 >>/var/log/remove.log
    fi
}

#显示.recycle内文件
recyclelist()
{
    ls -alsh \$TRASH|more
}

#mv文件到当前目录下
undormtorecycle()
{
    if [ "\$1" = "" ];then
    echo "Usage:undorm  <filename>"
    else
    mv -i \$TRASH\$@ ./
    fi
}

#清除.recycle内的文件
clearrecycle()
{
    read -p "Clear .recycle now ?[y/n]" confirm
    [ \$confirm == 'y' ] || [ \$confirm == 'Y' ] && /bin/rm -rf \$TRASH/*

}
#mv替换rm代码段结束
#end
EOF
source  ~/.bashrc
