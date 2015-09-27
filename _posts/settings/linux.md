---
#用户相关
##sudo add user
##/etc/passwd
用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell
http://os.51cto.com/art/201003/187533.htm

---
#search
##find
find /tmp -mtime +30 -type f -name *.sh[ab] -exec rm -f 
find . -mtime +30 -type f | xargs rm -rf
 find /home/oracle/test6 -cmin +20 -type f -name *.xml -exec rm -f
mtime来查找，因为在ls -al显示出来的就是mtime时间戳
ctime(change time, 而不是create time), atime(access time), mtime(modify time)

find . -name "*.c"  -exec grep array /dev/null {} \;
find . -name "message*.xml" -print |xargs grep 'AlertDataQ'


##grep
grep -C 5 foo file 显示file文件里匹配foo字串那行以及上下5行
grep -B 5 foo file 显示foo及前5行
grep -A 5 foo file 显示foo及后5行

##encoding
iconv -f encoding -t encoding inputfile
-f From 某个编码
-t To 某个编码
-o 输出到文件

---
#system setting
##date
date -s 11:25:00
##thread
ps -eLf 
top H
##内存
top
free -m
pmap -d $PID

##mount
mount -o loop disk1.iso /mntmount/iso

---
#Software setup
##gcc rpm安装包
mpfr-devel-2.4.1-6.el6.x86_64.rpm
cpp-4.4.7-4.el6.x86_64.rpm

glibc-2.12-1.132.el6.x86_64.rpm 
glibc-common-2.12-1.132.el6.x86_64.rpm  
glibc-devel-2.12-1.132.el6.x86_64.rpm 
glibc-headers-2.12-1.132.el6.x86_64.rpm 
kernel-headers-2.6.32-431.el6.x86_64.rpm
libgcc-4.4.7-4.el6.x86_64.rpm 
libgomp-4.4.7-4.el6.x86_64.rpm
ppl-0.10.2-11.el6.x86_64.rpm
cloog-ppl-0.15.7-1.2.el6.x86_64.rpm

##apt
https://www.debian.org/doc/manuals/apt-howto/ch-apt-get.zh-cn.html
###source setting
    /etc/apt/apt.conf

sudo apt-get update
apt-cache search
###installs
sudo apt-get install 
###upgrade
apt-get upgrade
###del
apt-get remove package
apt-show-versions -p logrotate
apt-get autoclean

apt-get -u dselect-upgrade



---
#网络相关
##wget
http://java-er.com/blog/wget-useage-x/
##代理
PROXY=http://proxy.xj.petrochina:8080
http_proxy=$PROXY
https_proxy=$PROXY
ftp_proxy=$PROXY
no_proxy=10.,192.
export http_proxy https_proxy ftp_proxy no_proxy
http://os.51cto.com/art/200908/141449.htm

##防火墙
chkconfig iptables off

##DNS
cat /etc/resolv.conf
echo 'nameserver 10.33.176.66' >/etc/resolv.conf
search localdomain
###mac
sudo dscacheutil -flushcache

##tcpdump
tcpdump -i eth0 -A tcp port 1414 and host 10.185.234.14
tcpdump -i eth0 -d tcp port 1414 and host 10.185.234.14
host 10.185.234.14 tcp port 1414

tcpdump -nt -s 500 port domain 

##Network ubuntus
### netstat
netstat -pan|grep '14:1414'




/etc/network/interfaces
auto eth0                  #设置自动启动eth0接口
iface eth0 inet static     #配置静态IP
address 192.168.11.88      #IP地址
netmask 255.255.255.0      #子网掩码
gateway 192.168.11.1        #默认网关
/etc/resolve.conf
nameserver 114.114.114.114
nameserver 114.114.115.115
sudo /etc/init.d/networking restart
sudo ifconfig eth0 192.168.1.81 netmask 255.255.255.0
sudo route add default gw 192.168.1.1
sudo ifconfig eth0 down
sudo ifconfig eth0 up
paralle desktop 无网络：http://bbs.feng.com/read-htm-tid-6881868-page-3.html


##namp
nmap -sT -O localhost

---
#SSH
##ssh认证
http://www.cnblogs.com/jdksummer/articles/2521550.html
ssh-keygen -t rsa
chmod o-w ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ps -Af | grep agent 

select * from t_operation where operator = 'jason' and 
operatetime < to_date('2015-04-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and operatetime >to_date('2015-03-10 00:00:00', 'yyyy-mm-dd hh24:mi:ss')

java -jar wls1034_generic.jar -mode=console

; 静默安装用如下方式启动:

java -jar wls1034_generic.jar -mode=console -silent_xml=/path_to_silent.xml

###配置
/etc/ssh/sshd_config 
###重启
/etc/rc.d/init.d/sshd restart
###批量ssh
http://www.theether.org/pssh/
pssh在多个主机上并行地运行命令
-h 执行命令的远程主机列表,文件内容格式[user@]host[:port]
如 test@172.16.10.10:229
-H 执行命令主机，主机格式 user@ip:port
-l 远程机器的用户名
-p 一次最大允许多少连接
-P 执行时输出执行信息
-o 输出内容重定向到一个文件
-e 执行错误重定向到一个文件
-t 设置命令执行超时时间
-A 提示输入密码并且把密码传递给ssh(如果私钥也有密码也用这个参数)
-O 设置ssh一些选项
-x 设置ssh额外的一些参数，可以多个，不同参数间空格分开
-X 同-x,但是只能设置一个参数
-i 显示标准输出和标准错误在每台host执行完毕后

pscp 传输文件到多个hosts，类似scp
    pscp -h hosts.txt -l irb2 foo.txt /home/irb2/foo.txt
pslurp 从多台远程机器拷贝文件到本地
pnuke 并行在远程主机杀进程
    pnuke -h hosts.txt -l irb2 java
prsync 使用rsync协议从本地计算机同步到远程主机
    prsync -r -h hosts.txt -l irb2 foo /home/irb2/foo

repo仓库
http://www.cnblogs.com/51xzdy/archive/2012/03/05/2380198.html

ibus-daemon -d

---
#语言相关
##输入法
http://blog.csdn.net/shanshu12/article/details/7339152
##ubuntu 中文
http://www.cnblogs.com/badwood316/archive/2010/03/06/1679965.html
apt-get install language-pack-zh
/etc/environment
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"
/var/lib/locales/supported.d/local：
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_CN.GBK GBK
zh_CN GB2312
en_GB.UTF-8 UTF-8
locale-gen
/etc/default/locale
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"
###切换到应为
LANG=”en_US.UTF-8″
LANGUAGE=”en_US:en”
再在终端下运行：
locale-gen -en_US:en


---
#开关机
##shutdown,reboot
shutdown -h now
shutdown -r now














