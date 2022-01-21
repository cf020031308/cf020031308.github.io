# UniMP：用于半监督分类的统一信息传递模型

标题不好翻，反正这模型流传也广（主要还是大厂宣传）就借了个标题。

Idea不稀罕，mask掉部分label之后将feature和label给combine后输入模型（label先嵌入到feature空间）去预测unmask的label。

里面有一小段证明是说这种combine可以同时传播feature和label，但证明时“为简便”忽略掉了activator，所以也没啥可看的（感觉这风气不好啊，忽略掉activator的网络就是个线性变换，简化得太过头了）。
