# 方差削减（Variance Reduction）

在分布p上采样估计$f$的期望$\mathbb E_p f(x)$时，可以用一些方法降低样本的方差

## 重要性采样

由重要性采样（Importance Sampling）
$$\mathbb E_p f(x) = \mathbb E_q [\frac{p(x)}{q(x)} f(x)]$$
方差为
$$\mathbb D_q [\frac{p(x)}{q(x)} f(x)] = \mathbb E_q [\frac{p(x)}{q(x)} f(x)]^2 - \mathbb E_p^2 f(x)$$
由Jensen不等式，当且仅当$f(X) \ge 0$且
$$q(X) = \frac{p(X)f(X)}{\mathbb E_p f(X)}$$
时方差为0（每一项都为常数了）。

从未归一项$p(X)f(X)$可以看出来，最好的采样分布应多采概率大且函数值影响大的（这就叫重要性）。

## 基线

引入已知期望的函数$g(X)$，令
$$\hat f(X) = f(X) - \alpha (g(X) - \mathbb E g(X))$$
则$\hat f(X)$的期望与$f(X)$相同，但方差
$$\mathbb D \hat f(X) = \mathbb D f(X) - 2\alpha \text{cov}(f(X), g(X)) + \alpha^2 \mathbb D g(X)$$
当$\alpha = \frac{\text{cov}(f(X), g(X))}{\mathbb D g(X)}$时该方差最小，为
$$\mathbb D \hat f(X) = (1 - \text{corr}(f(X), g(X))) \mathbb D f(X)$$

f, g的相关性越高，方差越小。也可以理解为，f中总有的那一部分（g）可以先抽出来，剩下的残差期望平移，方差变小。
