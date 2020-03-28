# 机器学习中的优化算法

$$w_{t+1} = w_t - \alpha \cdot m_t \odot V_t^{-1/2}$$

这里的 -1/2 是逐元素求平方根倒数

| 算法名   | 一阶动量 $m_t$                                              | 二阶动量 $V_t$                                                                          | 改进点                                               | 缺点                                         |
|----------|-------------------------------------------------------------|-----------------------------------------------------------------------------------------|------------------------------------------------------|----------------------------------------------|
| SGD      | $g_t = \triangledown f(w_t)$                                | 1                                                                                       |                                                      | 震荡                                         |
| SGD-M    | $EMA(g_t, \beta_1)$                                         | 1                                                                                       | 引入惯性，抑制震荡                                   | 陷入局部最优解                               |
| SGD-NAG  | $\triangledown f(w_t - \alpha \cdot EMA(g_{t_1}, \beta_1))$ | 1                                                                                       | 靠惯性多走一步，跳出局部最优                         | 各参数的学习率相同                           |
| AdaGrad  | $g_t$                                                       | $\sum\limits_{s=1}^{t} g_s \odot g_s$                                                   | 累积了较多更新经验的参数受单个样本影响小，较少的则大 | 学习率单调递减至 0                           |
| RMSProp  | $g_t$                                                       | $EMA(g_t \odot g_t, \beta_2)$（避免为 0 通常加个小量，下同）                            | 避免二阶动量积累导致训练提前结束                     | 二阶动量震荡，模型可能不收敛                 |
| AdaDelta | $g_t$                                                       | $\frac{EMA(g_t \odot g_t, \beta_2)}{EMA(\Delta w_{t-1} \odot \Delta w_{t-1}, \beta_3)}$ | 不失增量的单位，物理上好解释                         |                                              |
| AdaM     | $EMA(g_t, \beta_1)$                                         | $EMA(g_t \odot g_t, \beta_2)$                                                           |                                                      | 早期样本影响大，后期学习率太低，结果往往次优 |
| NAdaM    | $\triangledown f(w_t - \alpha \cdot EMA(g_{t_1}, \beta_1))$ | $EMA(g_t \odot g_t, \beta_2)$                                                           |                                                      |                                              |
|          |                                                             | $\max(EMA(g_t \odot g_t, \beta_2), V_{t-1})$                                            | 使学习率单调递减，保证模型收敛                       |                                              |
|          |                                                             |                                                                                         | 前期用 AdaM，快；后期切 SGD，准                      |                                              |

* $EMA(x_t, \beta) = \beta \cdot EMA(x_{t-1}, \beta) + (1 - \beta) \cdot x_t$
* 经验值：$\beta_1 = 0.9, \beta_2 = 0.999$
