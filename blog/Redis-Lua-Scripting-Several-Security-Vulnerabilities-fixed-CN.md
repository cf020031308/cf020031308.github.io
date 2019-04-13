# Redis Lua 脚本：修复了一些安全漏洞

> 原文链接: [http://antirez.com/news/119 ](http://antirez.com/news/119)  
> 原文题目: Redis Lua scripting: several security vulnerabilities fixed 

一个多月前我收到一封来自 Apple 信息安全团队的邮件。他们在一次审计中发现了一个 Redis Lua 子系统中的安全问题，具体来说是在 cmsgpack 库中。这个库并非 Lua 的一部分，而是我自己按 MessagePack 实现的。在一次合并一个功能改进的 pull request 时引入了安全问题。后来他们又发现了 Lua struct 库的一个新问题，同样这个库也不是 Lua 的，至少不是我们用的这版 Lua 的：我们才刚把源码嵌入到自己的 Lua 实现里，以便能给 Redis 用户使用的 Lua 解释器添加一些功能。然后我就发现了该 struct 库的另一个问题，接着 Alibaba 团队也发现了许多 cmsgpack 的其他问题，并定位了调用这些 Lua API 的代码。我迅速地就被一堆 Lua 相关的漏洞淹没了。

这些漏洞更多地是影响在云端提供托管 Redis 服务器这一特定场景，毕竟没有 Redis 服务器权限的话，要利用已发现的漏洞几乎不可能：很多 Redis 用户根本就用不到 cmsgpack 或 struct 库，即使用也不大可能用在不可信的输入上。但云服务提供商就不同了：他们的 Redis 实例（通常有多种租约）是开放给了订阅服务的用户的。他或她可以发送任何东西给这些 Redis 实例，触发漏洞、破坏内存、影响甚至完全操控 Redis 进程。

比如这个 Python 小程序就能击溃 Redis，利用了 cmsgpack 其中一个漏洞。

[https://gist.github.com/antirez/82445fcbea6d9b19f97014cc6cc79f8a ](https://gist.github.com/antirez/82445fcbea6d9b19f97014cc6cc79f8a)

不过站在能控制 Redis 实例的输入的普通用户的角度来看，风险仅限于将不可信的内容传入诸如 `struct.unpack()` 的函数，还得首先刚好选到一种危险的解码格式 `bc0` 作为格式参数。

## 沟通协调

多亏了 Apple 信息安全团队、我，和 Redis 云服务提供商之间的积极配合和友好交流，我先联系上了所有重要的 Redis 提供商，尽量协调漏洞的发布，好让他们能先一步打上补丁。我提供了一个独立补丁，使得提供商能轻易应用到他们的系统中。最后从昨天到今天我准备了 Redis 3、4 和 5 的新的修复版本，修复了安全性。你在看这篇博文时这些都已经发布了。  
不幸的是我没能联系上较小或较新的云服务提供商。处理与 Redis Lab, Amazon, Alibaba, Microsoft, Google, Heroku, Open Redis 和 Redis Green 的沟通已是竭尽全力，何况将信息扩散给其它主体将增加泄密的风险（各家公司都有很多人参与其中）。如果你是一名 Redis 服务提供商却今天才知道这个漏洞，我很抱歉，我已经尽力了。

感谢 Apple 信息安全团队以及其他提供商在这个问题上的提点与帮助。

## Lua 的问题

老实说设计 Redis 的 Lua 引擎时，我并没设想过这种顾客与云服务提供商相对立的安全模型。这多少假设了 Redis 服务器的使用者是可信的。所以 Lua 库普遍没有经过安全审查。当时觉得你要是都有 Redis API 的权限了，你怎么都能干得比这更不安全。

不过后来事情就变了，云服务提供商限制了开放给顾客的 Redis API，以使提供托管的 Redis 实例成为可能。但拒绝了 CONFIG 或 DEBUG 这类命令，就不可避免地要开放 EVAL 和 EVALSHA（译者注：两个都是用来执行 Lua 脚本的命令）。Redis Lua 脚本是社区里最常用到的功能之一。

因此在我真正留意到之前，Lua 库也已因 Redis 开放给最终用户的方式发生变化而日渐成为本该由 Redis 处理的安全模型中的一个攻击点。如前所述，在这模型中相比 Redis 用户，是托管 Redis “云”服务提供商受影响更多，但无论如何这是个必须解决的问题。

我们能做些什么来改进云服务提供商目前在安全方面的状态，并兼顾 Lua 脚本的具体问题呢？我列出了一些事情，想在接下来的几个月去做。

1. Lua 栈保护。貌似 Lua 可以通过编译以一些性能的牺牲来保证 Lua 栈 API 不被滥用。公正地说，我觉得 Lua 提出的关于栈的假设有点太琐碎了，Lua 库的开发者得一直检查栈上是否有足够的空间来压入一个新的值。其它同等抽象的语言有 C API，就没这个问题。所以我要好好考虑下在 Lua 底层 C API 中增加防范措施的低效是否可以接受。
2. 安全审计与模糊测试。尽管时间有限，我仍给 Lua struct 库做了些模糊测试。我将继续检查这领域的其它 Bug。肯定还有更多的问题，我们发现的 Bug 只是部分，这仅仅是因为之前没有多余的时间能投入到脚本子系统中。所以这是将要进行的一个重要的事情。在结束后我会再与 Redis 供应商协调，以使他们能及时打上补丁。
3. 从 Redis 用户的角度来说，有不可信数据发往 Lua 引擎时使用 HMAC （译者注：一种加密的哈希方法）来确保数据没被更改是很重要的。比如说有种流行的模式是把用户的状态存在用户自己的 cookie 里，以后再解码。这种数据后面可能被用作 Redis Lua 函数的输入。这个例子中一定要用 HMAC 来保证我们读到的是之前存储过的。
4. 更全面的 Lua 沙盒化。关于这个话题应该有大量的的文献和优秀实践。我们已有一些沙盒实现，但依据我的安全经历我感觉沙盒化归根结底就是个猫鼠游戏，不可能做到完美。比如追踪 CPU 或内存的滥用对 Redis 来说可能就太复杂了。但我们应至少能做到进程错误时“优雅”地退出，不产生任何内存内容错误。
5. 也许到了升级 Lua 引擎的时候了？我不确定新版的 Lua 是否从安全角度来说更先进，但我们有大量问题使得升级 Lua 会导致老的脚本可能无法运行。对 Redis 社区里的脚本，尤其是 Redis 用户随便写的那种，更先进的 Lua 版本的作用有限，这是一大问题。

## 相关 Issue

修复问题的提交如下：

```
ce17f76b 安全性: 修复 redis-cli 缓冲溢出。
e89086e0 安全性: 修复 Lua struct 库偏移量处理。
5ccb6f7a 安全性: 更多 cmsgpack 的修复，来自 @soloestoy。
1eb08bcd 安全性: 更新 Lua struct 库，提升安全性。
52a00201 安全性: 修复 Lua cmsgpack 库栈溢出。
```

第一个提交与此无关，是一个 redis-cli 的缓冲溢出，只有在命令行中传入一个很长的主机参数时才会被利用。其它的才是我们发现的 cmsgpack 与 struct 库的问题。

这是两个复现问题的脚本：

[https://gist.github.com/antirez/82445fcbea6d9b19f97014cc6cc79f8a ](https://gist.github.com/antirez/82445fcbea6d9b19f97014cc6cc79f8a)

[https://gist.github.com/antirez/bca0ad7a9c60c72e9600c7f720e9d035 ](https://gist.github.com/antirez/bca0ad7a9c60c72e9600c7f720e9d035)

两个都是苹果信息安全团队写的。但第一个我做了修改，以便能更稳定地复现。

## 影响到的版本

几乎所有带 Lua 脚本的 Redis 都受到了影响。

修复的版本为以下 github tag：

```
3.2.12 
4.0.10 
5.0-rc2 
```

稳定版（4.0.10）仍可在 [http://download.redis.io ](http://download.redis.io) 找到。

各发行版 tarball 文件的哈希值在此：

[https://github.com/antirez/redis-hashes ](https://github.com/antirez/redis-hashes)

请注意发行的版本中也包含了其他的修复，所以最好也读下版本说明，好了解切换到新版时其他会升级的东西。

希望再发博客时能带来为 Redis 的 Lua 脚本子系统规划的安全审计的报告。
