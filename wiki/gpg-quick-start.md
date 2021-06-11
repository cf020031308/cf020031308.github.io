# GPG 与文件、邮件加密

## 密钥与公钥管理

这里以 MacOS 下的 gpg 工具为例。

Windows 系统可选择：

1. 在 WSL 下使用 gpg
2. 使用 [Gpg4win](https://www.gpg4win.org/index.html)

### 生成自己密钥并发布公钥

```bash
> # 生成密钥与公钥（交互式的）
> # 生成后不满意可用 gpg --delete-secret-keys [ID] 和 gpg --delete-keys [ID] 删除
> gpg --full-gen-key

> # 查看本地公钥
> # 下面 47EB7384 开头的那一长串就是我的 ID
> gpg --list-keys
/Users/Roy/.gnupg/pubring.kbx
-----------------------------
pub   rsa4096 2020-02-28 [SC]
      47EB7384425BD613BC77D227201B9A6321856771
uid           [ultimate] Yi LUO <luoy@std.uestc.edu.cn>
sub   rsa4096 2020-02-28 [E]

> # 上传公钥，之后告诉同事自己的 ID 或邮箱
> gpg --keyserver hkp://pgp.mit.edu:80 --send-keys [ID]
```

### 公钥与密钥导入导出

```bash
# 导入
gpg --import
# 导出公钥
gpg --armor -o gpg.pub --export
# 导出私钥
gpg --armor -o gpg.sec --export-secret-keys
```

### 导入他人公钥

```bash
> # 按对方的 [ID/mail] 查找公钥后导入（交互式的）
> gpg --keyserver hkp://pgp.mit.edu:80 --search-keys [ID/mail]
```

## 对文件加密

```bash
> # 如果要加密文件传输给对方
> # 用 [ID/name/mail] 指定对方公钥加密文件 data.csv 生成 data.csv.gpg
> gpg --encrypt --recipient [ID/name/mail] data.csv

> # 如果收到对方给自己的加密文件
> # 使用自己私钥解密
> gpg --output data.csv --decrypt data.csv.gpg
```

## 对邮件加密

在邮箱中配置 PGP 可以加密信息，适用于通信。

这里以 mutt 客户端的配置为例：

```muttrc
source /usr/local/Cellar/mutt/1.13.0/share/doc/mutt/samples/gpg.rc
set pgp_default_key = "201B9A6321856771"
```

其中 source 所引用的文件是 mutt 自带的 gpg 配置，引用过来后在下面配置默认 key 为自己的就可以。

其它邮箱客户端请按关键词自行搜索，如百度“thunderbird gpg4win”、“hotmail gpg4win”。
