# Zathura: vi 键位的 PDF 阅读器

[Zathura](https://pwmt.org/projects/zathura/) 是个支持类似 vi 键位的 PDF 阅读器，适合键盘流用户（我）。

优点：

* 全键盘操作
* 惊艳的反色模式

缺点：

* 性能不好，尤其是反色模式时。连续多翻几页刷新就跟不上。
* 目前安装的这个软件没有包名（MacOS 平台），不能配合 karabiner 设置快速呼出的按键，只能 Cmd + Tab 切换，这样就常常需要找，就慢。

因为缺点太严重，后来发现 Chrome 插件 [SurfingKeys](https://github.com/brookhong/Surfingkeys) 不但能用 vi 的键位浏览网页，也能用于用 Chrome 浏览 PDF，于是就换成了用 Chrome 看 PDF。

## 安装流程

参考 https://github.com/zegervdv/homebrew-zathura

```bash
brew tap zegervdv/zathura
brew install cask xquartz
brew install zathura zathura-pdf-poppler

mkdir -p $(brew --prefix zathura)/lib/zathura
ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib

echo 'set selection-clipboard clipboard
set recolor "true"
set recolor-keephue "true"
set smooth-scroll "true"
' > ~/.config/zathurarc
```

## 键位小抄

* `t/^f/^b/y`  一页
* `^t/^d/^u/^y` 半页
* `gg/G/nG` 开头/结尾/n页
* `^o/^i` move backward/forward through the jump list
* `a/d/s` best-fit/dual-page/width-mode
* `o/O` open document
* `f` follow links
* `r` rotate
* `^r` 反色，护眼
* `R` reload
* `Tab` show index
  * `l/L` expand entry/all
  * `h/H` collapse entry/all
* `ma` 标记a位置（用过vim的都知道的。。）
* `'a` 跳转到标记a位置
* `:bmark` xxx 创建书签
* `:bdelete` 删除书签
* `:blist` 列出书签
* `:info
