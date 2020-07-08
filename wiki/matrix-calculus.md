# 矩阵微积分

## 定义

向量对向量的偏导称 Jacobian Matrix
$$J = \frac{\partial{y_{(n)}}}{\partial{x_{(m)}}} = \begin{pmatrix}
\frac{\partial{y_1}}{\partial{x_1}} & \cdots & \frac{\partial{y_1}}{\partial{x_m}} \\\\
\vdots & \ddots & \vdots \\\\
\frac{\partial{y_n}}{\partial{x_1}} & \cdots & \frac{\partial{y_n}}{\partial{x_m}}
\end{pmatrix}_{n \times m}$$

标量对向量的偏导、向量对标量的偏导都是相应向量为一维的情况。


这里采用了称为分子布局的表示方法，另外还有将矩阵（向量）微积分表示为这里这种形式的转置的，称为分母布局。  
但用分母布局表示时，下面的运算法则没有这么好记的形式。

## 运算

与标量微积分对比：

* 加法法则不变 $$\frac{\partial{y + z}}{\partial{x}} = \frac{\partial{y}}{\partial{x}} + \frac{\partial{z}}{\partial{x}}$$
* 链式法则不变 $$\frac{\partial{z}}{\partial{x}} = \frac{\partial{z}}{\partial{y}} \cdot \frac{\partial{y}}{\partial{x}}$$
* 乘法法则形式不变 $$\frac{\partial{y \otimes z}}{\partial{x}} = y \otimes \frac{\partial{z}}{\partial{x}} + z \otimes \frac{\partial{y}}{\partial{x}}$$
  1. 向量内积 $$\frac{\partial{y^Tz}}{\partial{x}} = y^T \cdot \frac{\partial{z}}{\partial{x}} + z^T \cdot \frac{\partial{y}}{\partial{x}}$$
  2. 矩阵乘积（A 与 x 无关） $$\frac{\partial{Ay}}{\partial{x}} = A \cdot \frac{\partial{y}}{\partial{x}}$$
  3. 向量数乘（y 或 z 为标量） $$\frac{\partial{yz}}{\partial{x}} = y \cdot \frac{\partial{z}}{\partial{x}} + z \cdot \frac{\partial{y}}{\partial{x}}$$
