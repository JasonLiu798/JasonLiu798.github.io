---
title: "IDEA jetty maven多模块热部署"
date: 2017-03-20T12:02:11+08:00
tags: ["code","ide","IDEA"]
topics: ["code","ide"]
draft: false
---




# IDEA jetty maven多模块热部署
IDEA这个IDE虽然很好用，但是jetty插件这块问题很多，这里总结下遇到的坑，并给出一个目前用的比较舒服而且免费的解决方案。

先说下需求和背景：
开发web项目，如果没有热部署，调试会很麻烦，重启一次服务器那就是漫长的等待。虽然良好测试用例和mock可以减少服务器的重启，但是有些地方还是必须要开启服务器来调试。
稍微大点的项目做好模块划分也是很重要的，否则随着项目越来越大，代码结构越来越不清晰，找对应的代码需要略过许多不相关的模块。
所以IDE对于maven多模块的热部署是个比较重要的功能。

单模块的maven web项目可以直接参考这篇文章：[在idea使用jetty](http://blog.csdn.net/xiejx618/article/details/49936541)，热部署等功能都能正常使用。

但是maven多模块项目在我目前使用的2016.v1这个版本目前遇到一个比较大的bug，就是配好的Artifacts，会不定时的配置会丢失，启动完项目后，各种报错，结果才发现是配好的其他模块没有被加载了，很蛋疼，而且改一次配置至少得1~2分钟，加上重启服务器，差不多五六分钟就没了。

因此配了maven自己的jetty插件，没想到坑更大，首先配置可以参考这个[maven多模块jetty如何热部署](https://www.oschina.net/question/1383717_129478)，但是实际配完<scanTargets> <extraClasspath>这两个标签并不能产生对应的效果，虽然插件可以扫到其他模块了，但是每修改一次文件，热部署并不能生效，而是服务器整体重启一次
插件官网并没有搜到其他有效信息，Stackoverflow上搜到这个[Maven jetty plugin - automatic reload using a multi-module project](http://stackoverflow.com/questions/25725552/maven-jetty-plugin-automatic-reload-using-a-multi-module-project)，尝试后多个配置后，仍然不能实现热部署。

然而，idea这么好用的ide居然连jetty热部署都无法很好支持吗？对面的eclipse上的jetty可是跑的很溜啊，好吧，既然IDE本身没有什么好的解决方案，那就从eclipse入手吧，查了eclipse上的插件，发现是个开源项目，还在maven库上有包，那就更好办了


        <dependency>
            <groupId>net.sourceforge.eclipsejetty</groupId>
            <artifactId>eclipse-jetty-starters-jetty9</artifactId>
            <version>3.9.0-SNAPSHOT</version>
        </dependency>









