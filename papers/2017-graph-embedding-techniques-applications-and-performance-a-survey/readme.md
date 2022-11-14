# 综述：图嵌入方法、应用、效果

## 效果衡量指标

对节点多分类任务，用 [macro-F1 和 micro-F1](/wiki/performance-measure/)。

对网络重建与链接预测任务，有以下两个指标（不过链接预测多用 AUC 和 AP）：

* precision@k（或 Pr@k）指预测分数最高的 k 个链接中，真实存在的链接所占比例。
* MAP（Mean Avearage Precision）：各个节点为出发点预测边的 AP 的平均值，实现时需要过滤掉真实出度为 0 的点，因为这种点的 AP 无意义
  * AP（Average Precision）：在 k 从 1 遍历到最大值（默认为预测数）的过程中，对每个 True Positive 计算当时的 Pr@k，最后求平均

```python
# AP 的计算

# 1. 用 sklearn，支持多分类
from sklearn import metrics
ap = metrics.average_precision_score(y_true, y_pred)

# 2. 自己写
k = y_true[y_pred.sort(descending=True).indices].long()
d = 1 + torch.arange(k.shape[0])
aps = torch.Tensor([k[:i].sum() for i in d]) / d
ap = aps[k.bool()].mean()
```
## 应用

1. 网络压缩（网络化简）：减少图中的边，目的是使存储空间更少，下游算法更快
2. 可视化：用 PCA 或 t-SNE 降维后绘图
3. 聚类：用 k-means 给图嵌入做聚类，作者说研究的较少，不过我理解这就是“社群发现”任务
4. 链接预测：大多数图嵌入方法都是要让节点表示包含结构信息，通常都是在优化链接预测的准确率
5. 节点分类

## 实现

作者开源的 [GEM 库](https://github.com/palash1992/GEM)中实现了很多图嵌入方法，看起来复用很方便，star 也多（但是我选择自己写）。
