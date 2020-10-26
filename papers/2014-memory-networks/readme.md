# 记忆网络

## 框架

* memory m：把 RNN 的内部记忆抽象出来了，空间更大，也可以有更多操作
* components：各部件的具体实现随便，比如 SVM、决策树
  * I-input feature map：对输入处理为内部表示
  * G-generalization：将输入更新到记忆中
  * O-output feature map：根据输入与记忆给出输出的内部表示
  * R-response：将输出的表示变换为期望样式的响应
* 流程：跟 RNN 差不多，就是把隐状态换成记忆了
  1. 输入更新记忆: m = G(m, I(x))
  2. 返回：R(O(m, I(x)))

components 全实现为 NN 就称为 Memory Neural Networks (MemNNs)。

## 一个 QA 的基本模型


假设输入是经过断句处理后的问句 x

* I(x) = x
* G 把 I(x) 存到 m 中下一个空位
* O 从 m 中找出 k 个相关句子，如 k = 2 时 $$\begin{aligned}
o_1 &= \mathop{\arg\max}\limits_{i=1, \cdots, N} s_O(x, m_i) \\\\
o_2 &= \mathop{\arg\max}\limits_{i=1, \cdots, N} s_O([x, m_{o_1}], m_i)
\end{aligned}$$
* R 输出最合适的词作为回答 $$r = \mathop{\arg\max}\limits_{w \in W} s_R([x, m_{o_1}, m_{o_2}], w)$$


里面的两个 s 都是使用点积模型计算表示相关性的打分函数。

训练时 $[x, o_1, o_2, r]$ 都作为监督数据。
