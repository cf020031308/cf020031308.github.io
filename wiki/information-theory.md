# 信息论

* 自信息（Self Information）$$I(x) = -\log P(x)$$
* 熵（Entropy）$$H(X) = E_X[I(x)]$$
  * 方差一定时，正态分布的熵最大
* 困惑度（Perplexity）$$2^H(X) 或 2^H(p, q)$$
* 联合熵（Joint Entropy）$$H(X, Y) = E_{X,Y}[-\log P(x, y)]$$
* 条件熵（Conditioned Entropy）$$H(X|Y) = E_{X,Y}[-\log \frac{P(x, y)}{P(y)}] = H(X, Y) - H(Y) = \sum\limits_{i=1}^{n} P(y_i) H(X|Y=y_i) = E_Y H(X|y)$$
* 互信息（Mutual Information，在决策树中衡量特征 Y 对数据集 X 的 Information Gain）$$I(X; Y) = E_{X,Y}[-\log \frac{P(x) P(y)}{P(x, y)}] = H(X) - H(X|Y) = H(Y) - H(Y|X) = H(X) + H(Y) - H(X, Y)$$
  * $I(X; Y) = 0 \Leftrightarrow X \perp Y$
* 交叉熵（Cross Entropy）$$H(p, q) = E_p[-\log q(x)]$$
  * p：数据的分布；q：编码的分布
  * p, q 越近，交叉熵越小
  * 交叉熵就是负的对数似然，最大似然估计就是使 H(数据频率, 估计分布) 最小
* 相对熵（Relative Entropy）/KL 散度（KL Divergence）$$D_{KL}(p \\| q) = H(p, q) - H(p) = E_p[-\log \frac{q(x)}{p(x)}] \ge 0$$
  * 等号成立当且仅当 p = q
  * d 维空间中，$D_{KL}(N(\mu_1, \Sigma_1) \\| N(\mu_2, \Sigma_2)) = \frac12(\text{tr}(\Sigma_2^{-1} \Sigma_1) + (\mu_2 - \mu_1)^T \Sigma_2^{-1} (\mu_2 - \mu_1) - d - \log \frac{|\Sigma_1|}{|\Sigma_2|})$
* JS 散度（JS Divergence）$$D_{JS}(p \\| q) = \frac12 D_{KL}(p \\| m) + \frac12 D_{KL}(q \\| m), m = \frac12 (p + q)$$
* p-Wasserstein Distance $$W_p(q_1, q_2) = \inf\limits_{\gamma(x, y) \in \Gamma(q_1, q_2)} E_\gamma[d(x, y)^p]^{\frac1p}$$
  * $\Gamma(q_1, q_2)$ 是边际分布为 $q_1$ 和 $q_2$ 的联合分布的集合
  * d(x, y) 为距离如 $l_p$ 距离
