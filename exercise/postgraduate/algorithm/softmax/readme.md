## Logistic Regression

因为 Logistic Regression 是 Softmax Regression 的类别数为 2 的特例，所以这里是调用的后面的 Softmax Regression，没有单独实现。

![logistic](logistic.png)

## Softmax Regression

将分类问题看作概率问题，并假设属于各个分类的概率的对数呈线性关系，按极大似然估算模型参数（或视交叉熵为损失函数令其最小化）。

![softmax](softmax.png)
