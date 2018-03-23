---
title: "IDEA maven多模块 使用jetty容器热部署解决方案"
date: 2017-06-20T00:00:00+08:00
tags: ["code","IDE","IDEA"]
topics: ["code","IDE"]
draft: false
---

接[IDEA maven多模块 使用jetty热部署]上文，尝试了IDEA自带的jetty插件（project structure的artifacts里的配置不定期丢失），maven的jetty插件（不能热部署，会导致整体重启），全都不能做到完美的多模块热部署，而eclipse的jetty插件这么好用，那就把移植过来吧，以下为具体解决方案...
<!--more-->

## 序
尝试了IDEA自带的jetty插件（project structure的artifacts里的配置不定期丢失），maven的jetty插件（不能热部署，会导致整体重启），全都不能做到完美的多模块热部署，而eclipse的jetty插件这么好用，那就把移植过来吧，以下为具体解决方案...

## 总体思路
* 找到eclipse jetty插件的入口函数
* 确定如何传参
* 获取或配置各类参数
* 启动

## 找入口函数
首先，在github上搜了一圈，找到了eclipse jetty插件的repo [eclipse-jetty-plugin](https://github.com/eclipse-jetty/eclipse-jetty-plugin)，[项目主页](http://eclipse-jetty.github.io/)翻了一遍，没发现什么有效信息
那就只好看源码了，git clone下拉了源码，下一步就是找到入口函数在哪。

先想到的思路，是从启动打印的那个logo入手，很快就搜到在类 net.sourceforge.eclipsejetty.starter.jetty9.Jetty9LauncherMain下的printLogo()函数内，被继承的抽象类内的launch()函数调用，lanuch被main调用，正好往上两行就是main函数了
```java
    /**
     * Calls the {@link #launch(String[])} method
     * 
     * @param args the arguments
     * @throws Exception on occasion
     */
    public static void main(String[] args) throws Exception
    {
        new Jetty9LauncherMain().launch(args);
    }

    /**
     * {@inheritDoc}
     * 
     * @see net.sourceforge.eclipsejetty.starter.common.AbstractJettyLauncherMain#printLogo(java.io.PrintStream)
     */
    @Override
    protected void printLogo(PrintStream out)
    {
        out.println("   ____    ___                   __    __  __         ___");
        out.println("  / __/___/ (_)__  ___ ___   __ / /__ / /_/ /___ __  / _ \\");
        out.println(" / _// __/ / / _ \\(_-</ -_) / // / -_) __/ __/ // /  \\_, /");
        out.println("/___/\\__/_/_/ .__/___/\\__/  \\___/\\__/\\__/\\__/\\_, /  /___/");
        out.println("           /_/                              /___/");
    }
```

## 传参分析
接下来看传参了，可以看到lanuch主要干的事就是从"jetty.launcher.configuration"配置中取到一个配置文件路径，加载文件内容
```java
    protected void launch(String[] args) throws Exception {
        long millis = System.currentTimeMillis();
        boolean showInfo = System.getProperty("jetty.launcher.hideLaunchInfo") == null;
        boolean consoleEnabled = System.getProperty("jetty.launcher.disableConsole") == null;
        if (showInfo) {
            this.printLogo(System.out);
        }

        String configurationFileDef = System.getProperty("jetty.launcher.configuration");
        if (configurationFileDef == null) {
            throw new IOException(String.format("-D%s missing", "jetty.launcher.configuration"));
        } else {
            File[] configurationFiles = getConfigurationFiles(configurationFileDef);
            ServerAdapter adapter = this.createAdapter(configurationFiles, showInfo);
            this.configure(System.out, adapter, configurationFiles, showInfo);
            if (showInfo) {
                adapter.info(System.out);
            }

            this.initConsole(consoleEnabled, adapter);
            adapter.start();
            if (showInfo) {
                this.printStartupTime(System.out, millis, consoleEnabled);
            }

        }
    }
```

## 配置文件分析
这个配置就在eclipse项目的最外面，找了一个，抽出一个模板，如下代码，中间需要替换的部分已经替换成了freemaker的变量（渲染直接用字符串替换也可以），主要的几个参数如下：
* port 监听端口
* webpath web主目录
* webcontext  context路径
* defaultsDescriptor 默认web.xml路径（可不配）
* extraClasspath 其他需要加载的classpath路径（重点！jar包，多模块的编译结果路径全配在这）

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Configure class="org.eclipse.jetty.server.Server" id="Server">
    <!-- Thread Pool -->
    <Get name="ThreadPool">
        <Set name="minThreads">1</Set>
        <Set name="idleTimeout">60000</Set>
        <Set name="detailedDump">false</Set>
    </Get>
    <!-- HTTP Config -->
    <New class="org.eclipse.jetty.server.HttpConfiguration" id="httpConfig">
        <Set name="secureScheme">https</Set>
        <Set name="outputBufferSize">32768</Set>
        <Set name="requestHeaderSize">8192</Set>
        <Set name="responseHeaderSize">8192</Set>
        <Set name="sendServerVersion">true</Set>
        <Set name="sendDateHeader">false</Set>
        <Set name="headerCacheSize">512</Set>
    </New>
    <!-- HTTP Connector -->
    <Call name="addConnector">
        <Arg>
            <New class="org.eclipse.jetty.server.ServerConnector">
                <Arg name="server">
                    <Ref refid="Server"/>
                </Arg>
                <Arg name="factories">
                    <Array type="org.eclipse.jetty.server.ConnectionFactory">
                        <Item>
                            <New class="org.eclipse.jetty.server.HttpConnectionFactory">
                                <Arg name="config">
                                    <Ref refid="httpConfig"/>
                                </Arg>
                            </New>
                        </Item>
                    </Array>
                </Arg>
                <Set name="port">${port}</Set>
                <Set name="idleTimeout">30000</Set>
            </New>
        </Arg>
    </Call>
    <!-- Handler -->
    <Set name="handler">
        <New class="org.eclipse.jetty.webapp.WebAppContext">
            <Arg type="java.lang.String">${webpath}</Arg>
            <Arg type="java.lang.String">${webcontext}</Arg>
            <Set name="defaultsDescriptor">${defaultsDescriptor}</Set>
            <Set name="extraClasspath">${extraClasspath}</Set>
        </New>
    </Set>
    <!-- Annotations -->
    <Call class="org.eclipse.jetty.webapp.Configuration$ClassList" name="setServerDefault">
        <Arg>
            <Ref refid="Server"/>
        </Arg>
        <Call name="addBefore">
            <Arg name="addBefore" type="java.lang.String">org.eclipse.jetty.webapp.JettyWebXmlConfiguration</Arg>
            <Arg>
                <Array type="java.lang.String">
                    <Item>
                        org.eclipse.jetty.annotations.AnnotationConfiguration
                    </Item>
                </Array>
            </Arg>
        </Call>
    </Call>
    <!-- JNDI -->
    <Call class="org.eclipse.jetty.webapp.Configuration$ClassList" name="setServerDefault">
        <Arg>
            <Ref refid="Server"/>
        </Arg>
        <Call name="addAfter">
            <Arg name="afterClass" type="java.lang.String">org.eclipse.jetty.webapp.FragmentConfiguration</Arg>
            <Arg>
                <Array type="java.lang.String">
                    <Item>org.eclipse.jetty.plus.webapp.EnvConfiguration</Item>
                    <Item>org.eclipse.jetty.plus.webapp.PlusConfiguration</Item>
                </Array>
            </Arg>
        </Call>
    </Call>
    <!-- Extra Options -->
    <Set name="stopAtShutdown">true</Set>
    <Set name="stopTimeout">1000</Set>
    <Set name="dumpAfterStart">false</Set>
    <Set name="dumpBeforeStop">false</Set>
</Configure>
```

## 生成配置文件
接下来就是怎么生成这个文件了，目前有两种方式：
第一种，在eclipse里，把项目导入，配好插件，生成xml；在IDEA里新建一个项目，jetty.launcher.configuration设置好eclipse生成的配置文件路径即可。

这种方式需要eclipse和idea都打开，配置不好的电脑容易卡，不过eclipse打开的唯一目的就是为了生成这个文件，可以把初始化的内存配置小点。好处就是方便，无需其他任何操作。

另一种，就是写代码生成了，这其中最麻烦的是获取运行需要的各种classpath；classpath分两种，分别是
* 各模块的 target/classes 路径
* 第三方jar包的实际路径
各模块的路径还是比较好获取，遍历一遍项目各模块目录，拼接即可。
但直接遍历无法处理的是，开发过程中，可能部分模块暂时不需要，也就是没法完全按pom.xml的配置精确指定要加载的模块，不过大多数时候，全部加载进路径能应付大多数情况。

第三方jar包的路径就比较不好获取了
第一种方案，要精确获取各类jar包，那必然要解析pom.xml，想到的一个思路是调用maven的接口去获取，而目前暂时没有多余时间去研究
第二种方案，借助IDE的配置文件，在IDEA的配置文件夹.idea里挨个看下即可发现jar包的实际路径在以下目录内.idea\libraries\xxx.xml，代码中要做的就是解析这些xml整合各个模块的依赖，最终生成classpath
第三种方案，那就是直接打出war包，把lib目录下的jar包全部拷出，去除项目源码生成的jar包，就是第三方的所有jar包，遍历解压后的目录，加入classpath即可，操作起来最简单，但问题也最大，那就是更新完第三方包后，必须重新进行以上操作，如果忘记了，很容易出现各种诡异bug。

由于第三方包变动不是很大，目前暂时采用第三种方案

## 完成
配置文件搞定后，剩下的就是在业务项目下建个模块，整合上面写好的代码，生成配置文件，调用eclipse插件，传入配置文件路径，点击debug运行项目，热部署正常，终于可以愉快的调试代码了。












