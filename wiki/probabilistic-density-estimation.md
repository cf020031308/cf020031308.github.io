# 概率密度估计

## 参数密度估计

根据先验知识假设随机变量服从某种分布（如正态分布、二项分布），但参数未知。  
之后最大似然化训练样本估计出参数。

如果模型中包含隐变量，就需要用 EM 算法进行估计。

![EM、VAE、GAN](em-vae-gan.jpg)

## 非参数密度估计

将空间划分为不同区域并估计每个区域的概率，以近似数据的概率密度函数。

### 直方图法（Histogram）

将空间划分为宽度（面积/体积/...）为 h 的区域，N 个样本有 K 个落入了某一个区域，则该区域内任意点的概率密度为 f = K / (Nh)。

### 核密度估计（Kernel Density Estimation）

又叫 Parzen 窗方法，是直方图法的改进（直方图估计的密度函数不连续）。


定义一个取值在 [0, 1] 内的核函数 I(z; x, h) 来表示样本 z 是否在以 x 为中心、宽度为 h 的区域内（可以理解为指示函数或贡献度函数）。

所以直方图法就是 I(z; x, h) = 0 或 1 的情况。


此外区域的范围也不一定要是刚性的。比如高斯核定义为
$$I(z; x, h) = \frac{1}{\sqrt{2 \pi}h} e^{-\frac{\\|z-x\\|^2}{2h^2}}$$
再远的样本也会对这个区域有贡献。

### K 近邻法（K-Nearest Neighbor）

核方法因为使用的是固定宽度的核，高密度区域的样本较多，固定大小的区域反映不出更多的分布细节，低密度区域的样本较少，在估计时会存在很大的随机性。

所以令每个区域都包含 K 个样本，则这些区域会有不同的宽度，兼顾到不同的密度。
