# 时间序列分析第四次作业

## 1. $\epsilon_t$ 是高斯白噪声 WN(0, 4)，二阶自回归模型为 $X_t - 0.1 X_{t-1} - 0.12X_{t-2} = \epsilon_t$。用该模型产生 N=200 个数据。

### 1. 计算该序列的均值估计 $\bar{X_N}$。

```javascript
var M = Math;
var N = 200, mu = 0, sigma = M.sqrt(4);
var s = 0, x = 0, x1 = 0, x2 = 0, eps = 0;
var ret = [];
for (var t = 1; t <= N; t++) {
  x2 = x1;
  x1 = x;
  eps = M.cos(2 * M.PI * M.random()) * M.sqrt(-2 * M.log(1 - M.random())) * sigma + mu;
  x = 0.1 * x1 + 0.12 * x2 + eps;
  s += x;
  ret.push([t, eps, x, s / t].join('|'));
}
ret.splice(0, 0, '时间\\\\模拟数据（均值：' + s / N + '）|.噪声|-X|-X均值', '-|-|-|-')
return ret.join('\n');
```

### 2. 求序列均值 $X_N$ 的置信度为 95% 的置信区间。

差分方程 $1 - 0.1z - 0.12z^w = 0$ 的根为 2.5 和 -10/3 显然都在单位圆外，所以该模型是平稳的。于是有
$$\Phi(B)\gamma_h = \begin{cases}
\sigma^2, &h = 0 \\\\
0, &h > 0
\end{cases}$$

由 $h \ge 2$ 时的递推式知通解为
$$\gamma_h = c_1 \cdot 0.4^h + c_2 \cdot (-0.3)^h$$

又由 $h \le 2$ 时的初始条件$$\begin{cases}
\gamma_0 - 0.1 \gamma_1 - 0.12 \gamma_2 &= \sigma^2 = 4 \\\\
\gamma_1 - 0.1 \gamma_0 - 0.12 \gamma_1 &= 0 \\\\
\gamma_2 - 0.1 \gamma_1 - 0.12 \gamma_0 &= 0
\end{cases}$$
解得 $$\begin{cases}
\gamma_0 &= \frac{11}{2.6754} \\\\
\gamma_1 &= \frac{1}{8.8} \gamma_0
\end{cases}$$
代入通解得 $$\begin{cases}
c_1 &= \frac{41}{104} \gamma_0 \\\\
c_2 &= \frac{63}{104} \gamma_0
\end{cases}$$

于是
$$\text{Var}(\sqrt{N}\bar{X_N}) = -\gamma_0 + 2 \sum\limits_{j=0}^{\infty} \gamma_j = -\gamma_0 + 2 \cdot (\frac{c_1}{1 - 0.4} + \frac{c_2}{1 + 0.3}) \approx 5.1232$$

所以信度 95% 的置信区间为 $[-1.96 \cdot \bar{\sigma} / \sqrt{N}, 1.96 \cdot \bar{\sigma} / \sqrt{N}]$ 即
$$[-4.4364/\sqrt{N}, 4.4364/\sqrt{N}]$$

### 3. 如果要求估计的绝对误差小于 1% 的概率大于 95%，请问至少需要多大的 N？

代入上面置信区间得 $N = (4.4364 / 0.01)^2 \approx 196812.8$，因此 N 至少为 196813。

## 2. ARMA(2, 1) 过程为 $X_t - 0.5X_{t-1} + 0.04X_{t-2} = \epsilon_t + 0.25\epsilon_{t-1}$，$\epsilon_t$ 是高斯白噪声 WN(0, $\sigma^2$)。求该序列的传递形式 $X_t = \sum_{j=0}^{+\infty} \varphi_j\epsilon_{t-j}$ 中的系数 $\varphi_j$。

$$(1 - 0.1B)(1 - 0.4B)X_t = (1 + 0.25B)\epsilon_t$$

左边差分方程的根分别为 10 和 2.5 都在单位圆外，所以模型是因果的，可以表示成传递形式，且有
$$X_t = \sum\limits_{j=0}^{\infty} (0.1B)^j \cdot \sum\limits_{j=0}^{\infty} (0.4B)^j \cdot (1 + 0.25B) \epsilon_t$$

对比系数有
$$\varphi_j = \sum\limits_{i=0}^{j} (0.1^i \times 0.4^{j-i}) + 0.25 \times \sum\limits_{i=0}^{j-1} (0.1^i \times 0.4^{j-i-1}) = \begin{cases}
0, &j = 0 \\\\
\frac{13 \times 4^j - 7}{6 \times 10^j}, &j > 0
\end{cases}$$

## 3. 对于 MA(2) 模型 $X_t = \epsilon_t - 0.66 \epsilon_{t-1} + 0.765 \epsilon_{t-2}$，$\epsilon_t$ 是高斯白噪声 WN(0, 4)，计算自协方差 $\gamma_0, \gamma_1, \gamma_2$ 和自相关系数 $\rho_0, \rho_1, \rho_2$。

由
$$\begin{cases}
\gamma_h = \sigma^2 \cdot \sum\limits_{k=h}^{q} \theta_k \theta_{k-h} \\\\
q = 2 \\\\
\sigma^2 = 4 \\\\
(\theta_0, \theta_1, \theta_2) = (1, -0.66, 0.765)
\end{cases}$$
得
$$(\gamma_0, \gamma_1, \gamma_2) = (8.0833, -4.6596, 3.06)$$
进而由 $\rho_h = \frac{\gamma_h}{\gamma_0}$ 得
$$(\rho_0, \rho_1, \rho_2) = (1, -0.5764, 0.3786)$$

## 4. 对于 ARMA(2, 2) 模型 $X_t - 0.1 X_{t-1} - 0.12 X_{t-2} = \epsilon_t - 0.6 \epsilon_{t-1} + 0.7 \epsilon_{t-2}$，$\epsilon_t$ 是高斯白噪声 WN(0, 1)，计算自协方差 $\gamma_k$。

左边差分方程 $1 - 0.1z - 0.12z^2 = (1 - 0.4z)(1 + 0.3z) = 0$ 的根为 2.5 和 -10/3 都在单位圆外，因此是因果的，于是有
$$X_t = \sum\limits_{j=0}^{\infty} \varphi_j \epsilon_{t-j} = \sum\limits_{j=0}^{\infty} (0.4B)^j \sum\limits_{j=0}^{\infty} (-0.3B)^j (1 - 0.6B + 0.7B^2) \epsilon_t$$
比较系数得
$$(\varphi_0, \varphi_1, \varphi_2) = (1, 0.1, 0.77)$$
又由
$$\Phi(B)\gamma_h = \sigma^2 \sum\limits_{j=0}^{q-h} \varphi_j \theta_{h+j}$$
得
$$\begin{cases}
\gamma_0 - 0.1 \gamma_1 - 0.12 \gamma_2 &= \varphi_0 \theta_0 + \varphi_1 \theta_1 \varphi_2 \theta_2 &= 1.479 \\\\
\gamma_1 - 0.1 \gamma_0 - 0.12 \gamma_1 &= \varphi_0 \theta_1 + \varphi_1 \theta_2 &= -0.53 \\\\
\gamma_2 - 0.1 \gamma_1 - 0.12 \gamma_0 &= \varphi_0 \theta_2 &= 0.77 \\\\
\gamma_h &= 0, &h > 2
\end{cases}$$
解得
$$\begin{cases}
\gamma_0 &\approx 1.5459 \\\\
\gamma_1 &\approx -0.4266 \\\\
\gamma_2 &\approx 0.9128 \\\\
\gamma_h &= 0, h > 2
\end{cases}$$
