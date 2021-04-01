# 图神经网络评估的不足


这篇文章通过对 GCN, MoNet, GraphSAGE, GAT 的实验指出了现有的图神经网络方法的评估可能是有问题的：即使按相同比例划分 train/validation/test 集，各集合中数据不同也可能导致不同的结果。


另外，在公平的调参下，GCN 的表现是最好的。  
这跟我在做 [ResLPA](https://github.com/cf020031308/ResLPA)  时的经验一致，现在很多模型弄得很复杂，达到 SotA 却大部分归功于调参，如果大家参数量都差不多，trick 尽量少，超参少一点或少调一点，其实 GCN 这种简单的模型非常有竞争力。


其实这些道理复现过一些模型的应该都懂，所以这篇文章最大的贡献可能在于又提供了四个数据集：Coauthor CS, Coauthor Physics, Amazon Computer, Amazon Photo。
