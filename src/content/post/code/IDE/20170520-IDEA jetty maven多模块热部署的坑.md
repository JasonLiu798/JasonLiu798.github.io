---
title: "IDEA jetty maven多模块热部署的坑"
date: 2017-03-20T12:02:11+08:00
tags: ["code","IDE","IDEA"]
topics: ["code","IDE"]
draft: false
---

IDEA这个IDE虽然很好用，但是jetty插件这块问题很多，这里总结下遇到的坑

<!--more-->

## 需求和背景
开发web项目，如果没有热部署，调试会很麻烦，重启一次服务器那就是漫长的等待。虽然良好测试用例和mock可以减少服务器的重启，但是有些地方还是必须要开启服务器来调试。
随着项目需求越来越多，做好模块划分也是很重要的，否则代码结构越来越不清晰，找对应的代码需要略过许多不相关的模块。
所以IDE对于maven多模块的热部署支持是个比较重要的功能。

单模块的maven web项目可以直接参考这篇文章：[在idea使用jetty](http://blog.csdn.net/xiejx618/article/details/49936541)，热部署等功能都能正常使用。

但是maven多模块项目在我目前使用的2016.v1这个版本目前遇到一个比较大的bug，就是配好的Artifacts，会不定时的配置会丢失，启动完项目后，各种报错，结果才发现是配好的其他模块没有被加载了，很蛋疼，而且改一次配置至少得1~2分钟，加上重启服务器，差不多五六分钟就没了。

因此配了maven自己的jetty插件，没想到坑更大，首先配置可以参考这个[maven多模块jetty如何热部署](https://www.oschina.net/question/1383717_129478)，但是实际配完<scanTargets> <extraClasspath>这两个标签并不能产生对应的效果，虽然插件可以扫到其他模块了，但是每修改一次文件，热部署并不能生效，而是服务器整体重启一次
插件官网并没有搜到其他有效信息，Stackoverflow上搜到这个[Maven jetty plugin - automatic reload using a multi-module project](http://stackoverflow.com/questions/25725552/maven-jetty-plugin-automatic-reload-using-a-multi-module-project)，尝试后多个配置后，仍然不能实现热部署。

解决方案请看[IDEA maven多模块 使用jetty容器热部署解决方案]

---------
目前已经更新到了IDEA的2017.2.6，jetty多模块配置后，不定时配置丢失的bug仍然未修复






