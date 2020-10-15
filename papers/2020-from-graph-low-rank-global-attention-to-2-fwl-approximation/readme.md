# 低秩全局注意力 (Low-Rank Global Attention, LRGA)


注意到这论文是因为这方法上了 [OGB 的链接预测任务排行榜](https://ogb.stanford.edu/docs/leader_linkprop/)，此外还有很多这方法与 2-FWL 的理论分析，之前没有这方面的积累，所以只看了方法的那一小节。


LRGA 可以附加到任何 GNN 上：
$$X^{l+1} = [X^l, \text{LRGA}(X^l), \text{GNN}(X^l)]$$

这里方括号表示拼接，但看[作者代码](https://github.com/omri1348/LRGA)是没有拼入第一项 $X^l$ 的。


LRGA 计算如下：

$$\begin{aligned}
A(X) &= \frac{n}{(1^Tm_1(X))(m_2(X)^T 1)} \cdot m_1(X)m_2(X)^T \\\\
\text{LRGA}(X) &= [A(X) m_3(X), m_4(X)]
\end{aligned}$$

其中 $m_1, m_2, m_3, m_4$ 都是到 k 维的 MLP。  
A 可以看作对注意力权重的一个低秩（如果 k 较小）的估计。实际计算注意力部分时，先计算 $m_2(X)^T m_3(X)$ 可使复杂度降低为 $O(k^2n)$。
