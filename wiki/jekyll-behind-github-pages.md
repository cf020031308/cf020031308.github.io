# Github Pages 背后的 Jekyll

在代码仓库 settings 中开通 [Github Pages](https://help.github.com/en/github/working-with-github-pages/getting-started-with-github-pages) 后，该仓库目标位置（`gh-pages` 分支、`/` 或 `/docs/`）的 markdown 文件会在 Github 的服务器上被 [Jekyll](https://jekyllrb.com) 渲染为同名的 html 文件，以提供网页服务。

关于 Github Pages 和 Jekyll 的关系，[官方文档](https://help.github.com/en/github/working-with-github-pages/about-github-pages-and-jekyll)是个不错的开始。

本文研究以下需求所涉及的知识：

1. 改善 SEO 并增加页面功能
2. 尽可能少地在仓库里增加代码文件
3. 尽可能少地依赖 Github 与 Jekyll

## [Jekyll 项目结构](https://jekyllrb.com/docs/structure/)

一个较简单的 Jekyll 项目的文件结构如下：

```shell
.
├── _config.yml
├── _posts
│   └── 2020-03-14-jekyll-behind-github-pages.md
├── about.md
├── readme.md
├── _layouts
│   ├── default.html
│   ├── post.html
│   └── page.html
└── _includes
    ├── footer.html
    └── header.html
```

* [配置文件](https://jekyllrb.com/docs/configuration/default/)：`/_config.yml`
* post：格式为 `/_posts/YYYY-mm-dd-title.md` 的文件，将被渲染为网页 `/YYYY/mm/dd/title.html`
* 索引页：任一目录中都会依次查找使用 `index.md` 或 `readme.md` 用以生成 `index.html`。比如 `/foo/readme.md` 对应网页的路径为 `/foo/index.html`，甚至访问 `/foo` 也可以
* 其它页：如 `about.md`。Github Pages 会将所有非下划线开头的路径中的 markdown 文件转为对应名字的网页。
* 网页模板：使用 [Liquid](https://shopify.github.io/liquid/) 编写的模板文件（就是带 {`% if true %`} {`{ var | filter }`} {`% endif %`} 一类标记的 html 或 markdown）
  * layout：`/_layouts/` 里是 layout 模板。markdown 文件的内容会[嵌入到以下 layout](https://github.com/benbalter/jekyll-default-layout)中作为最终的网页：
    1. `/index.md` 或 `/readme.md` 依次尝试 `home.html`、`page.html` 和 `default.html`
    2. post 会依次尝试 `post.html` 和 `default.html`
    2. 其它 markdown 文件依次尝试 `page.html` 和 `default.html`
  * 组件：`/_includes/` 通常是 layout 中抽取出的公共部分，在 layout 中通过如 {`%include footer.html %`} 引入

## [网页模板中的变量](https://jekyllrb.com/docs/variables/)

### page: Markdown 的元信息

虽然 Jekyll 要求 markdown 文档开头要有 **Front Matter**（即首尾各一行 `---` 的 yaml 片段），如：

```markdown
---
title: "My Real Title"
my_diy_var: "my_diy_value"
---
# My Fake Title

blah blah
```

等价于如下 yaml 对象：

```yaml
title: "My Real Title"
my_diy_var: "my_diy_value"
content: "<h1> My Fake Title </h1> <p> blah blah </p>"
```

该对象在 layout 中名为 `page`，于是可以这样用：`<h1> {`{ page.title }`} </h1>{`{ page.content }`}`

但实际上，在 Github Pages 中[可以没有 Front Matter](https://github.com/benbalter/jekyll-optional-front-matter)，[title 等字段可以从文档中推断出来](https://github.com/benbalter/jekyll-titles-from-headings)。

*注：其它文件如 html、sass 等开头也可以加 Front Matter，但意义不大。*

### site: 网站元信息与数据文件

另一个 layout 中可用的重要变量是 `site`，内容如下：

1. `_config.yml` 中的字段，例如 `site.twitter_username`
2. 下划线开头的一级目录（`/_*/`）中的元信息或数据文件，例如
   1. `/_data/` 中的 markdown/yaml/json/csv/tsv 可以用 `site.data` 遍历
   2. `/_authors/roy.json` 可以用 `site.authors.roy` 得到
3. [所属代码仓库的基本信息](https://github.com/jekyll/github-metadata)，如 `site.title` 默认是代码仓库的名字

## [使用现成的 Jekyll 主题](https://help.github.com/en/github/working-with-github-pages/adding-a-theme-to-your-github-pages-site-using-jekyll)

我之前的用法是不做任何主题的定制，除了自己写的简陋索引页外只有 markdown 文档，详情参见 [Code Less, Talk More](../blog/design-and-implementation-of-my-blog/readme.md)。

也可以在仓库 settings 中选择 [官方支持的主题](https://pages.github.com/themes/)，比如选 minima。这等价于在 `_config.yml` 中配置 `theme: minima`

或者可以在网上找个自己满意的 [Jekyll 主题](http://jekyllthemes.org/)，比如 [minimal-mistakes](https://github.com/mmistakes/minimal-mistakes)，就下载到本地或在 `_config.yml` 中配置 `remote-theme: mmistakes/minimal-mistakes`

## 本地使用 Jekyll

Jekyll 是一个 ruby 包，安装需要使用 ruby 自带的包管理器 gem。

```bash
# 在 MacOS 用 brew 安装 ruby
brew install ruby
echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 用 gem 安装 jekyll 与官方建议的 bundler
# 但因 MacOS 系统限制需要用 -n 绑定执行程序的路径，否则安装后找不到可执行文件
gem install -n /usr/local/opt/ruby/bin jekyll bundler

# 在当前路径下初始化一个项目
jekyll new blogtest

# 在本地安装依赖并运行服务
cd blogtest
bundle install
jekyll serve
```

初始项目本身比较简单，`_config.yml` 中看到使用的主题是 minima。

可以使用 `bundle info minima` 找到本地的 minima 代码，或者在 [minima 的 Github 仓库](https://github.com/jekyll/minima) 下载，以此为起点学习或做点定制开发。

## 其它资源

* [我的博客现状](blog.md)
