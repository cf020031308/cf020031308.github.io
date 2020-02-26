# 选举预测调研

## 目标

通过机器学习的方式，结合公共信息对台湾的大选结果做出预测。

## 数据

通常分为以下几类：

* **新闻**：媒体所报道的选举相关或候选人相关的新闻；
* **民意调查**：不同民间调查机构针对某一次选举在线上或街头做的问卷调查，通常是直接询问被调查者支持哪位候选人；
* **社交媒体**：来自 Twitter、Facebook、垂直论坛等线上社区的用户评论内容；
* **宏观经济数据**：如金融数据（GDP、就业率等）、人口数据（年龄构成、地区分布等）等；
* **其它**：如候选人相关网站的流量与候选人的搜索引擎热度。

## 方法

### UGC 的文本情绪分析

这是较多的论文所采用的方法。

* 用户原创内容（User Generated Content, UGC）
* 中文分词
* 关键词提取（TF-IDF）
* word2vec
* 基于贝叶斯的情绪分析

### 较宏观数据的拟合预测方法

部分论文采用神经网络为主的拟合方法，因此不一定有预测能力，反而可能滞后。

* 前馈神经网络
* 向量自回归预测模型

### 民意调查的概率图模型

需要主观建模，模型假设是否有效对结果影响很大。

### 民意的疾病传播模型

* 扩散模型

### 信号的卡尔曼滤波器

### 新闻事件侦测模型

# refs

2013-dynamic-bayesian-forecasting-of-presidential-elections-in-the-states
2014-prediction-and-analysis-of-pakistan-election-2013-based-on-sentiment-analysis
2015-buzzer-detection-and-sentiment-analysis-for-predicting-presidential-election-results-in-a-twitter-nation
2015-on-predictability-of-rare-events-leveraging-social-media-a-machine-learning-perspective
2015-using-twitter-sentiment-to-forecast-the-2013-pakistani-election-and-the-2014-indian-election
2016-boosting-election-prediction-accuracy-by-crowd-wisdom-on-social-forums
2016-forecasting-canadian-elections-using-twitter
2017-forecasting-at-scale
2017-prediction-of-the-2017-french-election-based-on-twitter-data-analysis
2017-web-mining-for-the-mayoral-election-prediction-in-taiwan
2018-forecasting-elections-using-compartmental-models-of-infection
2018-prediction-and-analysis-of-indonesia-presidential-election-from-twitter-using-sentiment-analysis
2018-social-media-would-not-lie-prediction-of-the-2016-taiwan-election-via-online-heterogeneous-data
2018-using-neural-networks-to-predict-the-2018-midterm-election
2019-forecasting-the-israeli-elections-using-pymc3
