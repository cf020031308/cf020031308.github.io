# 信息论

* 自信息（Self Information）$$I(x) = -\log P(x)$$
* 熵（Entropy）$$H(X) = E_X[I(x)]$$
  * 方差一定时，正态分布的熵最大
* 困惑度（Perplexity）$$2^H(X) 或 2^H(p, q)$$
* 联合熵（Joint Entropy）$$H(X, Y) = E_{X,Y}[-\log P(x, y)]$$
* 条件熵（Conditioned Entropy）$$H(X|Y) = E_{X,Y}[-\log \frac{P(x, y)}{P(y)}] = H(X, Y) - H(Y)$$
* 互信息（Mutual Information）$$I(X; Y) = E_{X,Y}[\log \frac{P(x, y)}{P(x) P(y)}] = H(X) - H(X|Y) = H(Y) - H(Y|X)$$
  * $I(X; Y) = 0 \Leftrightarrow X \perp Y$
* 交叉熵（Cross Entropy）$$H(p, q) = E_p[-\log q(x)]$$
  * p：数据的分布；q：编码的分布
  * p, q 越近，交叉熵越小。最大似然估计就是使 H(数据频率, 估计分布) 最小
* 相对熵（Relative Entropy）/KL 散度（KL Divergence）$$D_{KL}(p \\| q) = H(p, q) - H(p) = E_p[\log \frac{p(x)}{q(x)}] \ge 0$$
  * 等号成立当且仅当 p = q
* JS 散度（JS Divergence）$$D_{JS}(p \\| q) = \frac12 D_{KL}(p \\| m) = \frac12 D_{KL}(q \\| m), m = \frac12 (p + q)$$
* p-Wasserstein Distance $$W_p(q_1, q_2) = \inf\limits_{\gamma(x, y) \in \Gamma(q_1, q_2)} E_\gamma[d(x, y)^p]^{\frac1p}$$
  * $\Gamma(q_1, q_2)$ 是边际分布为 $q_1$ 和 $q_2$ 的联合分布的集合
  * d(x, y) 为距离如 $l_p$ 距离
