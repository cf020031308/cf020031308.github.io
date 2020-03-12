# Git Commit Message 规范与模板

## 业界标准：AngularJS

来自 [AngularJS 所用的规范](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.greljkmo14y0)，格式如下：

```
<type>(<scope>): <subject>

<body>

<footer>
```

各段内容说明：

* type: feat/fix/docs/refactor/perf/test/style/revert/chore
* scope: 影响范围（组件或文件），可省略
* subject: 第一人称现在时，动词开头，小写开头，英语 50 字符以内，结尾无句号
* body: 第一人称现在时，说明动机，与之前的对比，英语每行 72 字符以内
* footer: 与前不兼容的改动用 'BREAKING CHANGE:' 开头，给出修复方案。对 Issues 进行操作

## 自动生成 ChangeLog

标准化的 Git Commit Message 可以用工具过滤出 feat 和 fix 的 Commit 生成 ChangeLog，例如：

```bash
git log --format='%s (%h)' --reverse --grep '^\(feat\|fix\)' --since=2020-01-01 --before=2020-02-01 | sed 's/([^)]*):/:/' | sort -k1,1 -s
```

可以添加到 `~/.gitconfig` 里：

```ini
[alias]
    change-of-last-month = !sh -c 'git log --format=\"%s (%h)\" --reverse --grep \"^\\(docs\\|feat\\|fix\\|perf\\|refactor\\|test\\)\" --since=`date -v-1m +\"%Y-%m-01\"` --before=`date +\"%Y-%m-01\"` | sed \"s/([^)]*):/:/\" | sort -k1,1 -s' 
```

之后用 `git change-of-last-month` 就可以输出上个月的 ChangeLog。

## 配置模板

### 1. 自定义一个模板

[比如这是我的模板](https://github.com/cf020031308/cf020031308.github.io/blob/master/dotfiles/git/commit.tpl)，权作 Commit 时的提醒：

```txt
# feat/fix/docs/refactor/perf/test/style/revert/chore(scope/issue): changelog

# Modify issues if necessary
# Details if any
```

`#` 开头的行会被作为注释过滤掉。

### 2. 加入到 git 配置中

```bash
git config --global commit.template path/to/template
```

也可以在 `~/.gitconfig` 中手动添加

```ini
[commit]
    template = path/to/template
```

### 3. 提交时使用模板

之后提交时，使用 `git commit` 不带 `-m` 参数，就可以调出模板。
