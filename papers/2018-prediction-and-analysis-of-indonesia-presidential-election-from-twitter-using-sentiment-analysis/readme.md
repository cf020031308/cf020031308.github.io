# 基于 Twitter 情感分析的印度尼西亚总结选举预测与分析

@liangyh

* 应用：
  - 选举预测
* 数据：
  - 社交媒体
* 方法：
  - 文本情感分析

## 摘要

大数据包括社交网络网站，包括Twitter作为流行的微型博客社交媒体平台，用于政治竞选活动。Twitter上的爆炸性数据。

政治竞选的回应可以用来预测总统选举，就像在美国、英国、西班牙和法国等几个国家已经进行的预测政治选举一样。作者使用印度支那(Jokowi和Prabowo)总统候选人的推文，以及2018年3月至7月收集的用于情绪分析的相关标签的推文，预测印尼总统选举结果。作者提出了一种算法和方法，对重要数据进行统计，并对关键词进行训练，对模型进行训练，预测情感的极性。实验结果是用R语言产生的，表明Jokowi领先于当前的选举预测。这一预测结果对应于印尼的四个调查机构，证明了我们的方法产生了可靠的预测结果。

## 主要内容

使用推特数据（候选人推特的评论），针对包含某些政治标签的推特进行收集。

对于情感分析，由于数据量限制，作者使用包含250条推文的训练集和100条推文的测试集，并使用TextBlob进行两极化处理。作者使用5个月的数据获取每个人的top keywords。计算公式如下（只计算情感词的数量差异，没有考虑程度）：

```
Score = Number of positive words - Number of negative words
If Score > 0, this means that the sentence has an overall 'positive opinion'
If Score < 0, this means that the sentence has an overall 'negative opinion'
If Score = 0, then the sentence is considered to be a 'neutral opinion'
```

### 创新点

只针对包含某些政治标签的推特数据进行收集。

### 不足之处

只是简单的对推特数据进行自然语言处理，没有考虑例如水军、重复评论等其他相关因素，计算情感的公式只能适用于较为简单的情况，也需要改进。
