# Dynamic Bayesian Forecasting

## 大致方法

1. 假设选举结果是一个关于一些参数的先验的概率模型。
2. 从选举日开始，假设有个反向的 Bayesian random walk，去拟合已有的民调数据，得到参数。
3. 拿这些参数代入模型进行正向的预测。

## 公式中出现的符号

* i: 州，取值 1 ~ 50；
* j: 天，取值为 1 ~ J;
* $k_j$: 第 j 天前的 poll 数
* $n_k$: poll k 中的选民数
* $y_k$: poll k 中支持民主党的选民
* $h_i$: 州 i 的预测支持率
* $\pi_{ij}$: 州 i 于第 j 天的民主党支持率

## 推导过程

### State Level

$y_k$ 可以认为满足这样的二项式分布：
$$y_k \sim Binomial(n_k, \pi_{i[k]j[k]})$$


所以要想办法估计 $\pi_{ij}$，引入州级别的参数 $\beta_{ij}$ 和国级别的参数 $\delta_j$ 并假设：
$$logit(\pi_{ij}) = \beta_{ij} + \delta_j $$
$\delta_j$ 的存在是为了能让模型在某些州民调搞得少时也能通过别的州的结果有所估计而特意分解出来的，实际上可以认为 $ \delta_j = \beta_{ij}, \forall i $。


因此可以限制 $\delta_J = 0$，这样就有（但我没推出来）（这里关联起最后要求的 $h_i$ 了）
$$ \beta_{iJ} \sim N(logit(h_i), s_i^2) $$
这样就有了反向的 Bayesian random walk 的初值。其中的 $s_i^2$ 是一个先验值，表示该州结果的不确定性，需要事先设定。


之后就根据 $$ \beta_{ij} | \beta_{i,j+1} \sim N(\beta_{i,j+1}, \sigma_{\beta}^2) $$ 和 $$ \delta_j | \delta_{j+1} \sim N(\delta_{j+1}, \sigma_{\delta}^2) $$ 对已有民调数据进行拟合，得到 $\beta, \delta, \pi$的估计。

### Nation Level
