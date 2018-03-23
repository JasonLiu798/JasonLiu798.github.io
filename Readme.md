
# 常用
## 生成
hugo --theme=blackburn --baseUrl="https://JasonLiu798.github.io"
hugo --theme=hyde --baseUrl="https://JasonLiu798.github.io"


## 新建
hugo new post/useGit.md

## 调试
hugo server --theme=blackburn --buildDrafts
hugo server --theme=blackburn --buildDrafts --watch
hugo server --theme=hyde --buildDrafts --watch
hugo server --theme=tranquilpeak --buildDrafts --watch
hugo server --theme=hyde --buildDrafts

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

## 问题
### 无法登录
url变为：
http://jasonliu798.github.io/?error=redirect_uri_mismatch&error_description=The+redirect_uri+MUST+match+the+registered+callback+URL+for+this+application.&error_uri=https%3A%2F%2Fdeveloper.github.com%2Fapps%2Fmanaging-oauth-apps%2Ftroubleshooting-authorization-request-errors%2F%23redirect-uri-mismatch
打开 https://developer.github.com/apps/managing-oauth-apps/troubleshooting-authorization-request-errors/ 
检查发现url配置问题

### Error: Not Found
配置主题文件_config.yml时，格式错误，比如gitment前有空格也会造成代码生成问题；
Error: Not Found问题，repo库填写问题，详见[gitment issues 18](https://github.com/imsun/gitment/issues/18)
其他问题，参见作者项目的Issue
作者提醒使用本项目的用户，请保持克制，切勿滥用。详见 Gitment：使用 GitHub Issues 搭建评论系统


