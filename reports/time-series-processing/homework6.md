# 时间序列分析第六次作业

## 1. 对于 ARMA(2, 2) 模型 $X_t - 0.1X_{t-1} - 0.12X_{t-2} = \epsilon_t - 0.6 \epsilon_{t-1} + 0.7 \epsilon_{t-2}$，$\epsilon_t$ 是高斯白噪声 WN(0, 1)。请模拟产生一个长度为 1000 的动态数据。

```javascript
loadfile('ts.js');
const { ARMA, corr, forecast, parCorr, toTable } = _G;
const N = 1000;
const phis = [1, -0.1, -0.12];
const thetas = [1, -0.6, 0.7];
const p = phis.length - 1;
const q = thetas.length - 1;
const M = Math.max(2 * q, Math.round(N ** (1 / 3)));
const xs = ARMA(N, phis, thetas);
const gs = corr(xs, M);
const fs = forecast(gs);
const hs = parCorr(fs);
const belief = 1.96 / Math.sqrt(N);

// ${toTable('模拟数据', ['t', '-X'], xs.map((x, i) => [i + 1, x]))}
write(`
${toTable('自相关系数的估计', ['h', '$\\hat\\gamma_h$', '-置信下界', '-置信上界'], gs.map((g, h) => [h, g, -belief, belief]))}

${toTable('偏相关系数的估计', ['h', '$\\hat\\varphi_h$', '-置信下界', '-置信上界'], hs.map((h, k) => [k + 1, h, -belief, belief]))}
`)
return {p, q, xs, fs};
```

### 1. 请对模型的参数进行粗估计。

用逆函数法。

```javascript
const { p, q } = _G;
const _p = Math.max(p, q) + q;
write(`\n假设模型可逆并近似服从 AR(p')，其中 $$p' = \\max(p, q) + q = ${_p}$$`);

const vs = _G.fs[_p];
write(`\n由 Durbin-Levinson 递推法估计 AR(p')：$\\epsilon_t = \\Psi(B)X_t$ 得 $$\\varphi = (${vs})$$`);

const { range } = _G;
const ib = vs.map((_, i) => i).slice(-q);
const iA = ib.map(i => range(i - 1, i - q - 1, -1));
write(`\n由 $\\Phi(B) = \\Theta(B) \\Psi(B)$ 的后 q 个方程 $$\\begin{pmatrix} ${iA.map(r => r.map(i => '\\varphi_' + i).join(' & ')).join(' \\\\\\\\\n')} \\end{pmatrix} \\cdot \\theta + \\begin{pmatrix} ${ib.map(r => '\\varphi_' + r).join(' \\\\\\\\\n')} \\end{pmatrix} = 0$$`);

const { linSolve } = _G;
const ts = [1, ...linSolve(iA.map(r => r.map(i => vs[i])), ib.map(r => -vs[r]))]
write(`\n解得 $\\hat\\theta=(${ts.slice(1)})$（如果 |$\\hat\\theta$| < 1 则满足前面假设的可逆性）`);

const { sum, rconv } = _G;
const ps = new Array(p + 1).fill(0).map((_, k) => sum(rconv(ts.slice(0, k + 1), vs.slice(0, k + 1))));
write('\n又由 $-\\hat\\phi_k = \\sum\\limits_{i=0}^{k} \\hat\\theta_i \\varphi_{k-i}$（k = 1, ..., p） 得：\n')
ps.forEach((f, k) => k && write(`\n* $\\hat\\phi_${k}$ = ${-f}`));

return { ps, ts };
```

### 2. 请用最小二乘法对模型参数进行估计。

用前面粗估计得到的参数 $\hat\phi, \hat\theta$ 作为初值，通过
$$\hat\epsilon_t = X_t - \hat\phi_1 X_{t-1} - \hat\phi_{2} X_{t - 2} - \hat\theta_1 \hat\epsilon_{t-1} - \hat\theta_2 \hat\epsilon_{t-2}$$
递推（边界设为 0）得对噪声的估计

```javascript
const est_noises = () => {
  const { p, xs, ps, ts, sum, rconv } = _G;
  let ns = new Array(xs.length).fill(0);
  for (let i = p; i < ns.length; i++) ns[i] = sum(rconv(ps, xs.slice(0, i + 1))) - sum(rconv(ts, ns.slice(0, i + 1)));
  _G.ns = ns;
  return ns;
}
const { p, toTable } = _G;
write(`\n${toTable('噪声估计', ['t', '.$\\hat\\epsilon_t$'], est_noises().slice(p).map((n, i) => [i + p + 1, n]))}`);
return { est_noises };
```

代入 ARMA(2, 2) 模型有残差 $$\Phi(B) X_t - \Theta(B) \hat\epsilon_t = (X_t - \hat\epsilon_t) - (X_{t-1}, X_{t-2}, \hat\epsilon_{t-1}, \hat\epsilon_{t-2}) \cdot \begin{pmatrix} \phi_1 \\\\ \phi_2 \\\\ \theta_1 \\\\ \theta_2 \end{pmatrix}$$

由最小二乘法估计参数 $\hat\beta = (\phi_1, \phi_2, \theta_1, \theta_2)^T$，使每个时间点上的残差的平方和最小，则有
$$\begin{cases}
A^T A \cdot \beta = A^T \cdot \begin{pmatrix}
  X_{t_0} - \hat\epsilon_{t_0} \\\\
  X_{t_0 + 1} - \hat\epsilon_{t_0 + 1} \\\\
  \vdots \\\\
  X_N - \hat\epsilon_N
\end{pmatrix} \\\\
A = \begin{pmatrix}
  X_{t_0 - 1} & X_{t_0 - 2} & \hat\epsilon_{t_0 - 1} & \hat\epsilon_{t_0 - 2} \\\\
  X_{t_0} & X_{t_0 - 1} & \hat\epsilon_{t_0} & \hat\epsilon_{t_0 - 1} \\\\
  \vdots & \vdots & \vdots & \vdots \\\\
  X_{N - 1} & X_{N - 2} & \hat\epsilon_{N - 1} & \hat\epsilon_{N - 2}
\end{pmatrix} \\\\
t_0 = p + q + 1
\end{cases}$$

```javascript
const est_params = () => {
  const { p, q, xs, ns, tMat, linSolve, MatMul } = _G;
  const A = xs.map((_, t) => [xs[t - 1], xs[t - 2], ns[t - 1], ns[t - 2]]).slice(p + q);
  const y = xs.map((x, t) => x - ns[t]).slice(p + q);
  const tA = tMat(A);
  const b = linSolve(MatMul(tA, A), MatMul(tA, y));
  _G.ps = [1, ...b.slice(0, p).map(p => -p)];
  _G.ts = [1, ...b.slice(p)]
  return b;
}
write(`\n解得 $$\\hat\\beta = (${est_params()})^T$$`);
return { est_params };
```

重复用这组新估计的参数 $\hat\beta$ 估计噪声、最小二乘法估计参数，再迭代 3 次：

```javascript
const { sum, p, q, est_noises, est_params } = _G;
write(`|次数|${new Array(p).fill(0).map((_, i) => `$-\\hat\\phi_{${i+1}}$`).join('|')}|${new Array(q).fill(0).map((_, i) => `$\\hat\\theta_{${i+1}}$`).join('|')}|`);
write(`|${new Array(p + q + 1).fill('-').join('|')}|`);
for (let i = 1; i <= 3; i++) {
  est_noises();
  write(`|${i}|${est_params().join('|')}|`);
}
const { ns } = _G;
write(`\n用再估计的噪声的圴方来估计：$\\hat\\sigma = ${sum(ns.slice(p).map(n => n * n)) / (ns.length - p)}$`);
```

### 3. 请用最小平方和估计法对模型参数进行估计。

## 2. 请对第 1 题中模拟产生的动态数据进行两种方法以上的平稳性检验，并对参数估计后的白噪声估计 $\hat\epsilon_t$ 进行高斯白噪声检验。
