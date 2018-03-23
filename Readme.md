
# 常用
## 生成
```shell
hugo
hugo --theme=blackburn --baseUrl="https://JasonLiu798.github.io/"
hugo --theme=hyde --baseUrl="https://JasonLiu798.github.io"
```

## 新建
```shell
hugo new post/useGit.md
```

## 调试
```shell
hugo server --theme=blackburn --buildDrafts
hugo server --theme=blackburn --buildDrafts --watch
hugo server --theme=hyde --buildDrafts --watch
hugo server --theme=tranquilpeak --buildDrafts --watch
hugo server --theme=hyde --buildDrafts
```

# 主题
https://github.com/yoshiharuyamashita/blackburn
git clone git@github.com:yoshiharuyamashita/blackburn.git themes/blackburn

https://github.com/spf13/hyde
git clone git@github.com:spf13/hyde.git themes/hyde


---
# 评论
[Gitment：使用 GitHub Issues 搭建评论系统](https://imsun.net/posts/gitment-introduction/)
https://github.com/imsun/gitment

## 查看github ID
https://api.github.com/users/JasonLiu798

## 新建oauth app
https://github.com/settings/developers
## my 
https://github.com/settings/applications/690942
Client ID
c0bc10b2101e2a6101e2
Client Secret
d8ef1cd91f59ae0f842933cd2847772ac1274112

## 相关问题
[Gitment坑点小结](https://www.jianshu.com/p/57afa4844aaa)

### 无法登录
url变为：
http://jasonliu798.github.io/?error=redirect_uri_mismatch&error_description=The+redirect_uri+MUST+match+the+registered+callback+URL+for+this+application.&error_uri=https%3A%2F%2Fdeveloper.github.com%2Fapps%2Fmanaging-oauth-apps%2Ftroubleshooting-authorization-request-errors%2F%23redirect-uri-mismatch
打开 https://developer.github.com/apps/managing-oauth-apps/troubleshooting-authorization-request-errors/ 
检查发现url配置问题

### Error: Not Found
repo库填写问题，详见[gitment issues 18](https://github.com/imsun/gitment/issues/18)
owner填用户名，非用户id
实际请求url
https://api.github.com/repos/JasonLiu798/JasonLiu798.github.io/issues?creator=JasonLiu798&labels=https%3A%2F%2Fjasonliu798.github.io%2Fpost%2Fcode%2Fide%2F20170620-idea-maven%25E5%25A4%259A%25E6%25A8%25A1%25E5%259D%2597-%25E4%25BD%25BF%25E7%2594%25A8jetty%25E5%25AE%25B9%25E5%2599%25A8%25E7%2583%25AD%25E9%2583%25A8%25E7%25BD%25B2%25E8%25A7%25A3%25E5%2586%25B3%25E6%2596%25B9%25E6%25A1%2588%2F

### Error：validation failed
issue的标签label有长度限制！labels的最大长度限制是50个字符
id: '页面 ID', // 可选。默认为 location.href
这个id的作用，就是针对一个文章有唯一的标识来判断这篇本章。
在issues里面，可以发现是根据网页标题来新建issues的，然后每个issues有两个labels（标签），一个是gitment，另一个就是id。

所以明白了原理后，就是因为id太长，导致初始化失败，现在就是要让id保证在50个字符内。

### comment初始化
https://github.com/imsun/gitment/issues/5


### 其他
[其他问题，参见作者项目的Issue](https://github.com/imsun/gitment/issues)

[hexo](https://www.juhe.cn/news/index/id/1852)

配置主题文件_config.yml时，格式错误，比如gitment前有空格也会造成代码生成问题；
Error: Not Found问题，



