# 理解知识蒸馏中Mixup的作用：一项实证研究

本文指出Mixup与知识蒸馏的联系在于“平滑”，进而通过一系列实验提出做知识蒸馏时的一些策略。

下图说明Mixup与升高知识蒸馏的温度作用一样，都使表示更分散。

![feature representation](feature-repr.png)

下图第三点说明教师模型最好不要Mixup，否则会损害教师模型的监督效果。

![feature representation 2](feature-repr2.png)
