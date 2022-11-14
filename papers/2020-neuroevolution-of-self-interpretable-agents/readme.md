# 自解释智能体的神经进化

我分享了【Google AI Blog: Using Selective Attention in Reinforcement Learning Agents】, 快来看吧！@小米浏览器 | https://ai.googleblog.com/2020/06/using-selective-attention-in.html?m=1


通过自注意力，只选择最重要的一部分网格作为状态输入。

因为用了排序和切片等不可微的运算，不能使用反向传播训练，而用了些derivative-free optimization的方法，不知道具体是什么。


这样的agent有较强的泛化能力，稍微改动游戏环境并不影响。但如果改动很大，例如赛车游戏用了动态背景，注意力就全在背景上了，如果背景是视频，就完全不能工作，如果背景是噪点，注意力也在背景上但是根据这样的背景还是可以玩游戏的。


所以注意力会集中到变化剧烈的部分？这是注意力机制本身的性质吗？会因此影响其它领域如NLP的效果吗？如果知道原理进行回避能提升效果吗？


还顺便发布了 carRacingExt

论文在线版 https://attentionagent.github.io/
