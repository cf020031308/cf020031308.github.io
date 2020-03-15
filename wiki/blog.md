# 博客现况

1. 以文档为中心。尽量减少功能代码
2. 少依赖 Github
   1. 需要能比较简单地迁移到如 GitLab 的其它地方而不丧失主要功能。依次保障以下功能：
      1. 基本的 Markdown 渲染
      2. RSS 可用
      3. 命令行浏览器如 Lynx 可用
      4. 其它
   2. 页面中不要硬编码域名
3. 少依赖 Jekyll
   1. 已用 js 实现的功能不要换成 Jekyll/Liquid，更不要去写 ruby
   2. 未实现但 Jekyll 提供且可简单地配置出来的功能可以用
___
* 知识放 wiki 里，不要当博客发
* 论文笔记要兼容 papis 的结构，放 papers 里
* 其它文章放 blog 里
* TODO: ppt 改名 slides
* 博客及类似内容手写到 /blog/atom.xml 中，博客首页读 atom.xml 生成列表
___
引入了 Jekyll 的 `_config.yml` 文件，用作以下配置：

 * Markdown 语法设置为 GFM
 * 使用 [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) 生成 `/sitemap.xml`
___
以后增加 `_layouts/default.html` 文件，实现以下功能：

* 左侧
  * sitemap 转 sidebar
* 中间
  * 面包屑
  * LaTeX
  * 图表
* 右侧
  * search bar
  * share
  * TOC
  * Refs & notes
___
`/_posts/YYYY-mm-dd-title.md` 会被转换到 `/YYYY/mm/dd/title.md`，路径变了，不利于转出 Jekyll，故不使用 Jekyll 的方式管理 post。  
也因此，无法使用 [jekyll-feed](https://github.com/jekyll/jekyll-feed) 插件自动生成 ATOM 格式的 `/feed.xml`，继续手写 `/blog/atom.xml`。
