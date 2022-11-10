# 方差削减（Variance Reduction）


在分布p上采样估计$f$的期望$\mathbb E_p f(x)$时，可以用一些方法降低通过估计的方差

## 重要性采样（Importance Sampling）

$$\mathbb E_p f(x) = \mathbb E_q [\frac{p(x)}{q(x)} f(x)]$$


方差为
$$\mathbb D_q [\frac{p(x)}{q(x)} f(x)] = \mathbb E_q [\frac{p(x)}{q(x)} f(x)]^2 - \mathbb E_p^2 f(x)$$
若$f(X) \ge 0$，则由Jensen不等式，当且仅当
$$q(X) = \frac{p(X)f(X)}{\mathbb E_p f(X)}$$
时方差为0。


直观理解重要性：从未归一项$p(X)f(X)$可以看出，最稳定的采样应多采概率大且函数值影响大的。

例子：FastGCN, AS-GCN, GraphSAINT等

## 基线（Baseline）


引入已知期望的函数$g(X)$，令
$$\hat f(X) = f(X) - \alpha (g(X) - \mathbb E g(X))$$
易知期望不变$\mathbb E \hat f(X) = \mathbb E f(X)$，方差是关于$\alpha$的抛物线
$$\mathbb D \hat f(X) = \mathbb D f(X) - 2\alpha \text{cov}(f(X), g(X)) + \alpha^2 \mathbb D g(X)$$


因此$\alpha = \alpha_{\text{opt}} = \frac{\text{cov}(f(X), g(X))}{\mathbb D g(X)}$时方差最小，为
$$\mathbb D \hat f(X) = (1 - \text{corr}(f(X), g(X))) \mathbb D f(X)$$

由于$\alpha = 0$时f不变，由抛物线的性质知取$\alpha \in (0, 2\alpha_\text{opt})$得到的$\hat f$都可以减小方差。


因此，选择与f相关的g，取合适的$\alpha$得到$\hat f$可减小方差。f, g的相关性越高，方差越小。

直观理解g：可以理解g为从f中抽取的部分随机性，剩下的部分波动减小、方差变小。

例子：带基线的REINFORCE算法、VR-GCN等
