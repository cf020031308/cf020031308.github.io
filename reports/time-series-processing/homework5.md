# 时间序列分析第五次作业

## 1. ARMA(2, 1) 过程为 $X_t - 0.5X_{t-1} + 0.04X_{t-2} = \epsilon_t + 0.25\epsilon_{t-1}$，$\epsilon_t$ 是高斯白噪声 WN(0, 1)。求该序列的前 3 个偏相关系数 $\phi_{11}, \phi_{22}, \phi_{33}$，以及最佳线性预报系数 $\phi_{31}, \phi_{32}, \phi_{33}$。

因为左边差分方程 $1 - 0.5z - 0.04z^2 = 0$ 的根 z = 2.5 和 z = 10 都在单位圆外，所以模型是因果的。有
$$X_t = \sum\limits_{j=0}^{\infty} \varphi_j \epsilon_{t-j} = \sum\limits_{j=0}^{\infty} (0.1B)^j \sum\limits_{j=0}^{\infty} (0.4B)^j (1 + 0.25B) \epsilon_t$$
比较系数有
$$(\varphi_0, \varphi_1) = (1, 0.75)$$

又由
$$\Phi(B)\gamma_h = \sigma^2 \sum\limits_{j=0}^{q-h} \varphi_j \theta_{h+j}$$
当 h = 0, 1, 2 时的边界条件解得
$$(\gamma_0, \gamma_1, \gamma_2) = (\frac{169375}{99792}, \frac{421675}{399168}, \frac{367475}{798336})$$
以及当 h = 3 时的递推式知
$$\gamma_3 = 0.5\gamma_2 - 0.04\gamma_1 = \frac{300007}{1596672}$$
于是由 $\rho_h = \frac{\gamma_h}{\gamma_0}$ 知
$$(\rho_0, \rho_1, \rho_2, \rho_3) = (1, \frac{16867}{27100}, \frac{14699}{54200}, \frac{300007}{2710000})$$

所以由 Yule-Walker 方程组的递推公式依次得
$$\begin{aligned}
\phi_{11} &= \rho_1 &\approx 0.622 \\\\
\phi_{22} &= \frac{-\rho_2 + \rho_1 \phi_{11}}{-\rho_0 + \rho_1 \phi_{11}} &\approx -0.190 \\\\
\phi_{21} &= \phi_{11} - \phi_{22} \phi_{11} &\approx 0.740 \\\\
\phi_{33} &= \frac{-\rho_3 + \rho_2 \phi_{21} + \rho_1 \phi_{22}}{-\rho_0 + \rho_1 \phi_{21} + \rho_2 \phi_{22}} &\approx 0.047 \\\\
\phi_{31} &= \phi_{21} - \phi_{33} \phi_{22} &\approx 0.749 \\\\
\phi_{32} &= \phi_{22} - \phi_{33} \phi_{21} &\approx -0.225
\end{aligned}$$

综上：
$$(\phi_{11}, \phi_{22}, \phi_{33}) \approx (0.622, -0.190, 0.047)$$
$$(\phi_{31}, \phi_{32}, \phi_{33}) \approx (0.749, -0.225, 0.047)$$

## 2. 对于 ARMA(2, 2) 模型 $X_t - 0.1X_{t-1} - 0.12X_{t-1} = \epsilon_t - 0.6\epsilon_{t-1} + 0.7\epsilon_{t-2}$，$\epsilon_t$ 是高斯白噪声 WN(0, 1)。请模拟产生一个长度为 1000 的动态数据。计算前 10 个样本自协方差值 $\hat\gamma_k$ 与偏相关系数 $\hat\phi_{kk}$，并画出动态数据散布图、自相关图与偏相关图。

```javascript
loadfile('ts.js');
const { ARMA, corr, forecast, parCorr, toTable } = _G;

const xs = ARMA(1000, [1, -0.1, -0.12], [1, -0.6, 0.7]);
const gs = corr(xs, 10);
const hs = parCorr(forecast(gs));

write(`
${toTable('模拟数据散布图', ['t', '.X'], xs.map((x, i) => [i + 1, x]))}

${toTable('自相关图', ['k', '$\\hat\\gamma_k$'], gs.map((g, k) => [k, g]))}

${toTable('偏相关图', ['k', '$\\hat\\phi_{kk}$'], hs.map((h, i) => [i + 1, h]))}
`);
```

## 3. $X_t$ 满足 AR(5) 模型 $X_t - 1.4833 X_{t-1} + 0.8483 X_{t-2} - 0.2350 X_{t-3} + 0.0317 X_{t-4} - 0.0017 X_{t-5} = \epsilon_t \sim \text{WN}(0, 1)$。请模拟生成 500 个数据点，对模型的自回归系数和白噪声方差进行估计，并给出自回归系数为 0 的置信区间。

```javascript
const { ARMA, corr, forecast, sum, conv, toTable } = _G;
const N = 500;
const phis = [1, -1.4833, 0.8483, -0.2350, 0.0317, -0.0017];
const p = phis.length - 1;
const xs = ARMA(N, phis);
const gs = corr(xs, 20);
const hs = forecast(gs.slice(0, p + 1))[p];
const sigma2 = sum(conv(phis, gs));
const belief = 1.96 / Math.sqrt(N);

write(`
${toTable('模拟数据', ['t', '-X'], xs.map((x, i) => [i + 1, x]))}

${toTable('自相关系数的估计', ['h', '-$\\hat\\gamma_h$'], gs.map((g, h) => [h, g]))}

自回归系数的估计：

${hs.slice(1).map((h, i) => `* $\\phi_${i + 1} = ${-h}$`).join('\n')}

$\\epsilon_t$ 方差的估计：$\\hat{\\sigma}^2_\\epsilon = ${sigma2}$

置信区间 = [$-1.96N^{-1/2}, 1.96N^{-1/2}$] = [-${belief}, ${belief}]。
`);
```

## 4. 对于 MA(2) 模型 $X_t = \epsilon_t - 0.6 \epsilon_{t-1} + 0.7 \epsilon_{t-2}$，$\epsilon_t$ 是高斯白噪声 WN(0, 1)。请模拟产生一个长度为 1000 的动态数据。对模型的滑动平均系数和白噪声方差用三种方法进行估计，并给出滑动平均系数为 0 的置信区间。

```javascript
const { ARMA, corr, toTable } = _G;
const N = 1000;
const thetas = [1, -0.6, 0.7];
const q = thetas.length - 1;
const M = Math.max(2 * q, parseInt(N ** (1 / 3) + 0.5));
const xs = ARMA(N, [1], thetas);
const gs = corr(xs, M);

write(`
${toTable('模拟数据', ['t', '-X'], xs.map((x, i) => [i + 1, x]))}

${toTable('样本自相关系数', ['h', '-$\\hat\\gamma_h$'], gs.map((g, h) => [h, g]))}

样本自相函数是 ${q} 步截尾的，可以用 MA(${q}） 拟合。
`);
return {buf: { N, thetas, q, M, gs }};
```

### 1. 直接求解法

由
$$\begin{cases}
\gamma_0 &= \sigma^2 (1 + \theta_1^2 + \theta_2^2) \\\\
\gamma_1 &= \sigma^2 (\theta_1 + \theta_1 \theta_2) \\\\
\gamma_2 &= \sigma^2 \theta_2
\end{cases}$$
得
$$\begin{cases}
\sigma^2 &= \frac{\gamma_2}{\theta_2} \\\\
\theta_1 &= \frac{\gamma_1}{\gamma_2} \cdot (1 - \frac{1}{1 + \theta_2}) \\\\
f(\theta_2) &= \gamma_2 (1 + \theta_1^2 + \theta_2^2) - \gamma_0 \theta_2 = 0
\end{cases}$$
其中 $f(\theta_2)$ 的导数为
$$\frac{\partial{f}}{\partial{\theta_2}} = \frac{2\gamma_1^2\theta_2}{\gamma_2(1 + \theta_2)^3} + 2\gamma_2\theta_2 - \gamma_0$$
用最速度下降法求解 $\theta_2$（期间如果超出可逆域则重新赋初值），并代入前两式得

```javascript
const { gs } = _G.buf;
const sigma2 = theta2 => gs[2] / theta2;
const theta1 = theta2 => gs[1] * theta2 / gs[2] / (1 + theta2);
const equation = theta2 => gs[2] * (1 + (theta1(theta2) ** 2) + (theta2 ** 2)) - gs[0] * theta2;
const partial = theta2 => 2 * gs[1] * gs[1] * theta2 / gs[2] / ((1 + theta2) ** 3) + 2 * gs[2] * theta2 - gs[0];
const alpha = 0.1;
let theta2 = 0;
for (let m = 0; m < 1000; m++) {
  theta2 -= alpha * partial(theta2)
  if (Math.abs(theta2 ) > 1) theta2 = Math.random() * 2 - 1;
  else if (Math.abs(equation(theta2)) < 0.01) break;
}
write(`$$\\begin{cases}
\\theta_2 &= ${theta2} \\\\\\\\
\\sigma^2 &= ${sigma2(theta2)} \\\\\\\\
\\theta_1 &= ${theta1(theta2)}
\\end{cases}$$`);
```

### 2. 线性迭代法

```javascript
const { sum, conv, toTable, buf: { thetas, q, M, gs } } = _G;
const dt = 0.01, ds = _G.buf.ds = 0.01;
let ts = [[1, ...new Array(q).fill(0)]], s2s = [gs[0]];
let delta = 0;
for (let m = 1; m <= M; m++) {
  s2s[m] = gs[0] / sum(conv(ts[m - 1], ts[m - 1]));
  ts[m] = [1], delta = 0;
  for (let h = 1; h <= q; h++) {
    ts[m][h] = gs[h] / s2s[m] - sum(conv(ts[m - 1].slice(1), ts[m - 1].slice(h + 1)));
    delta = Math.max(delta, Math.abs(ts[m][h] - ts[m - 1][h]));
  }
  if (Math.abs(s2s[m] - s2s[m - 1]) < ds && delta < dt) break;
}
write(`
终止条件：

* $|\\hat\\theta_i(m) - \\hat\\theta_i(m-1)| \\lt ${dt}$
* $|\\hat\\sigma_\\epsilon^2(m) - \\hat\\sigma_\\epsilon^2(m-1)| \\lt ${ds}$
* 最多迭代 ${M} 次

${toTable('',
  ['迭代次数 m', '$\\hat\\sigma_\\epsilon^2$', ...(thetas.slice(1).map((_, i) => `$\\hat\\theta_{${i+1}}$`))],
  ts.map((tm, m) => [m, s2s[m], ...tm.slice(1)]))}
`);
```

### 3. 新息估计法

```javascript
const { newInfo, toTable, buf: { thetas, q, M, gs, ds } } = _G;
const [ts, vs] = newInfo(gs);
write(`
终止条件：

* $|\\hat{v}(m) - \\hat{v}(m-1)| \\lt ${ds}$
* 最多迭代 ${M} 次

${toTable('',
  ['迭代次数 m', ...(thetas.slice(1).map((_, i) => `$\\hat\\theta_{${i+1}}$`)), '$\\hat{v} \\rightarrow \\hat\\sigma_\\epsilon^2$'],
  ts.map((tm, m) => [m, ...[...tm, ...new Array(q + 1).fill('')].slice(1, q + 1), vs[m]]))}
`);
```

```javascript
const { N } = _G.buf;
const belief = 1.96 / Math.sqrt(N);
write(`置信区间 = [$-1.96N^{-1/2}, 1.96N^{-1/2}$] = [-${belief}, ${belief}]。`);
```
