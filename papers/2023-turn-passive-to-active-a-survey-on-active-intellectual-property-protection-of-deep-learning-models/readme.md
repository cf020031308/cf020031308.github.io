# 综述：深度模型知识产权的积极防护


当前对于深度模型的知识产权保护，主流研究是基于水印的。  
即模型产权拥有者在模型中嵌入水印，当模型疑似被盗后检测嫌疑模型中是否有水印，以主张权利。  
然而，基于水印的模型产权保护只能在模型被盗后辅助维权。

本文调研的方法致力于在模型被盗前进行主动防御，预期的效果是模型拥有者为每个认证用户发放指纹，用户携带指纹可正常使用模型，否则模型表现将极差。


![](passive_active.png)


本综述主要考查方法的以下两类功能

1. 模型权限（Autorization Control）
   * 能区分授权用户和未授权用户
   * 能区分不同的授权用户
   * 对不同用户提供不同的功能性，比如授权用户模型表现好，未授权则差
2. 用户权限（User's Identities Authentication and Management）
   * 能为不同用户生成不同指纹（fingerprint）
   * 指纹安全，例如防止伪造、派生指纹，防止共谋破解
   * 能验证指纹，即利用模型可以提取指纹、验证正确性并定位用户

但对于这两类功能的意义价值，本文阐述不够深入，缺少较具体的场景例子。

> 假设模型训练后可能给一些用户使用，而用户可能泄漏模型

## 主要方法

### Active DNN IP Protection: A Novel User Fingerprint Management and DNN Authorization Control Technique

> Xue, M., Wu, Z., He, C., Wang, J., & Liu, W., Trustcom 2020 (CCF-C)


1. 给图片插入共有N个信号的后门触发器训练得到模型
2. 对任一用户，选择N个信号中的n个插入10张图片当作他的指纹
3. 模型拥有者将N个信号输入模型，置信度拉满，可证明版权（就跟常规水印一样）
4. 用户用指纹输入模型，置信度适中，可验证权限


![](auth.png)

步骤2和4（上图中间一行）就很迷，拿DNN来鉴权。

### Deep Serial Number: Computational Watermark for DNN Intellectual Property Protection

> Tang, R., Du, M., & Hu, X., ECML-PKDD 2020 (CCF-B)

思路是使用知识蒸馏为每个用户训练一个专用模型，该模型需要使用该用户的序列号（Deep Serial Number, DSN）才能正常工作。


其中用到一个梯度反转层（Gradient Reversal Layer, GRL, 2015年提出），可看作简版对抗网络。  
先简单介绍一下。


![](grl.png)

* 对GRL之后的参数，没区别，优化目标还是提升判别器的判断能力
* 对GRL之前的参数，梯度乘以$-\lambda$相当于损失函数乘以$-\lambda$，优化目标成了不让判别器正确判断


![](dsn.png)

本文方法在训练时，序列号为真就走蓝色路径进行知识蒸馏，随机假序列号就走红色路径做对抗学习。  
是否有序列号会影响GRL之前的特征提取，有序列号就能提取出利于分类的信息，否则提取出无用信息。


### A Buyer-traceable DNN Model IP Protection Method Against Piracy and Misappropriation

> Wang, S., Xu, C., Zheng, Y., & Chang, C., AICAS 2022（非CCF)


先训练模型，再为每个用户加专属水印fine-tune出专属模型。  
还是Passive的防御模式，但因为可以定位到泄露者，比常规的水印保护强一丝。

联邦中已有FedCIP工作，但需要靠客户端加水印来抓泄露的客户端这有点奇怪。

### ActiveGuard: An Active DNN IP Protection Technique via Adversarial Examples

> Xue, M., Sun, S., He, C., Zhang, Y., Wang, J., & Liu, W., IET Comput. Digit. Tech. 2021 （四区）


![](active_guard.png)

看了这张图，并且由于还是Mingfu Xue的工作，就没看文章。  
猜测还是继承了之前那个很迷惑的思路：拿Control Layer（另一个DNN）来鉴权，然后根据鉴权结果决定是否使用受保护网络。

### Active intellectual property protection for deep neural networks through stealthy backdoor and users’ identities authentication

> Xue, M., Sun, S., Zhang, Y., Wang, J., & Liu, W., Applied Intelligence 2021 （三区，22年升二区）


![](additional-class.png)

Mingfu Xue前面工作的升级版，利用新开一个类别加隐写术的方法抵御query modification attack，没细看。

### Sample-Specific Backdoor based Active Intellectual Property Protection for Deep Neural Networks

> Wu, Y., Xue, M., Gu, D., Zhang, Y., & Liu, W., AICAS 2022（非CCF)


![](unet.png)

## 未来方向


**数据集的Authorization Control**

* 数据集加入后门就可以检验模型是否用到数据集（Passive）
* 还听说有种魔法水印可以让用它训练的模型效果变得很差（Active）


![](fedwm.png)

**如何与联邦学习结合**（目前主流也是水印，如图）

* 保护模型独占，或者定位泄漏参数的参与者（如FedCIP），等等
