---
title: "cygwin编译redis"
date: 2015-09-27T00:00:00+08:00
draft: false
---

由于经常使用cygwin，windows上又没有命令行版的redis客户端，因此准备编译一个，没想到遇到一个恶心问题。
<!--more-->


由于经常使用cygwin，windows上又没有命令行版的redis客户端，因此准备编译一个，没想到遇到一个恶心问题。

先到官网下了源码
``` shell
wget https://github.com/antirez/redis/archive/2.8.22.tar.gz
tar -zpxvf redis-2.8.22.tar.gz
```

cygwin需要安装gcc和make，使用setup.exe安装，安完后的环境

``` shell
$ gcc -v
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-pc-cygwin/4.9.3/lto-wrapper.exe
目标：x86_64-pc-cygwin

$ make -v
GNU Make 4.1
Built for x86_64-unknown-cygwin
Copyright (C) 1988-2014 Free Software Foundation, Inc.
```

编译需要修改几个源文件，参考[Windows 7 64位下编译Redis-2.8.3/Redis-3.0.1](http://my.oschina.net/maxid/blog/186506)

```
src/redis.h修改
/* Cygwin Fix */   
#ifdef __CYGWIN__   
#ifndef SA_ONSTACK   
#define SA_ONSTACK 0x08000000   
#endif   
#endif
/deps/hiredis/net.c 在 #include "sds.h"后增加以下代码
/* Cygwin Fix */   
#ifdef __CYGWIN__
#define TCP_KEEPCNT 8
#define TCP_KEEPINTVL 150
#define TCP_KEEPIDLE 14400
#endif
```

开始编译
```
cd deps
$ make lua hiredis linenoise
```

问题来了，提示了一堆类型找不到
```
/usr/include/netinet/tcp.h:54:2: error: unknown type name ‘u_short’
```

查看编译提示得知hiredis/net.c中include了<netinet/tcp.h>，tcp.h中需要u_short这些类型，这些类型都是定义在<sys/types.h>头文件中，检查代码并没有缺少include <sys/types.h>，使用gcc -v deps/hiredis/net.c，查看头文件搜索目录
```
#include "..." 搜索从这里开始：
#include <...> 搜索从这里开始：
 /usr/lib/gcc/x86_64-pc-cygwin/4.9.3/include
 /usr/lib/gcc/x86_64-pc-cygwin/4.9.3/include-fixed
 /usr/include
 /usr/lib/gcc/x86_64-pc-cygwin/4.9.3/../../../../lib/../include/w32api
搜索列表结束。
```

搜索到了/usr/include目录，而且目录下有sys/types.h

因此怀疑编译环境有问题，注意到make -v实际提示的
```
Built for x86_64-unknown-cygwin
```
x86后面跟的是unknown，而不是跟gcc-v一样的pc
尝试装了32位版的cygwin和编译环境，make -v
```
Built for x86-pc-cygwin
```

提示正常了，但编译后依旧如此提示错误，考虑到编译后主要使用客户端，那就只好先把#include <netinet/tcp.h>的相关代码全部注释了，之后make正常，make install ，redis-cli可用

然而
```
/usr/include/netinet/tcp.h:54:2: error: unknown type name ‘u_short’
```
这个提示在查找了很多资料都没找到解决办法，算是个遗憾。
