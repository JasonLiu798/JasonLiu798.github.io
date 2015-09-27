# .bashrc

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias psefj='ps -ef|grep java'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

#useful path
BGS=/root/Desktop/GpsBGServer/lib
LOG=/opt/logs
UP=/opt/upload
OPT=/opt
UBIN=/opt/bin
ISO=/mnt/iso
NETWORK=/etc/sysconfig/network-scripts
export BGS UP LOG OPT UBIN ISO NETWORK

#java
JAVA_HOME=/opt/java
WL=/opt/weblogic/user_projects/domains/GPSMonitor
CATALINA_HOME='/opt/tomcat'
TOMCAT=$CATALINA_HOME
CLASSPATH=.:$JAVA_HOME/lib
export JAVA_HOME WL CATALINA_HOME TOMCAT CLASSPATH

#hadoop
HB=/opt/hbase
HDP=/opt/hadoop
HADOOP_HOME=$HDP
HADOOP_PREFIX=$HDP
HADOOP_CONF_DIR=/etc/hadoop
ZP=/opt/ZOOKEEPER
export HDP HB ZP HADOOP_HOME HADOOP_CONF_DIR


#web
WWW=/opt/lampp/htdocs
export WWW

#bsh front end
WL1=/opt/weblogic/user_projects/domains/GPSMonitor/servers/srv1/tmp/_WL_user
CLS=tmp/WEB-INF/classes/cn/com/cnpc
export WL1 CLS TCLS

#bsh back end
NJCON=/root/Desktop/GpsBGServer/JTT809TransportServer
export NJCON

#proxy
PROXY=http://proxy.xj.petrochina:8080
http_proxy=$PROXY
https_proxy=$PROXY
ftp_proxy=$PROXY
no_proxy=10.,192.
export http_proxy https_proxy ftp_proxy no_proxy

#path
export PATH=$PATH:$JAVA_HOME/bin:/opt/bin:$CATALINA_HOME/bin:$HADOOP_HOME/bin
