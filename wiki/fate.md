# FATE调研

FATE是微众银行开源的隐私计算框架，已捐献给Linux基金会，支持同态加密、多方安全计算、联邦学习等。


![FATE Architecture Overview](https://github.com/FederatedAI/FATE/raw/master/doc/architecture/images/fate_architecture_overview.png)


## [FATE Cloud](https://github.com/FederatedAI/FATE-Cloud/blob/master/docs/FATE-Cloud%E4%BA%A7%E5%93%81%E4%BD%BF%E7%94%A8%E6%89%8B%E5%86%8C.pdf)


![跨组织多云联邦平台](https://github.com/FederatedAI/FATE-Cloud/raw/master/images/FATECloud.png)


Cloud平台主要功能

* 注册机构号及其下站点（奇怪为啥注册站点不放权给机构）
* 创建PartyID规则（一个Party只能属于数据使用方Guest或数据提供方Host中一种）
* 创建Exchange路由表，包含网关IP，用于站点之间通信（猜是不是NAT）


机构号主要功能

* 添加管理用户，有admin, dev, business三种角色，权限各异
* 申请查看其它机构下的站点信息（但有用的信息就只有PartyID）

## [FATE Flow](https://federatedai.github.io/FATE-Flow/latest/zh/fate_flow/)


![FATE Flow Architecture](https://federatedai.github.io/FATE-Flow/latest/zh/images/fate_arch.png)


FATE Flow包括Server和Client两部分，由Client连接Server进行操作，如发布任务、上传数据。

### 数据接入

两种方式：

1. Upload。导入到FATE Storage（就是转成计算引擎支持的格式），作业运行时从中读取
2. Bind。作业运行时Reader（相当于适配器）从外部存储（如HDFS/Hive/MySQL）读取并转存到FATE Storage（可能只做一次，相当于Upload在线版）

### 任务（作业） 


* DSL
  * 组件列表。描述任务将用到的各个模块
  * 模块。指定使用的组件
  * 输入。可直接输入数据或将某个模型输出作为输入
  * 输出。可输出数据或模型


* Conf
  * 发起方PartyID（和Role：Guest/Host）
  * 参与方。分角色：Guest/Host/Arbiter
  * 系统参数。建议手动设置的有job_type, task_cores, task_parallelism, computing_partitions, timeout, auto_retries, model_id, model_version
  * 组件参数


job_type可选train或predict。

完整的训练再预测比较麻烦，需要先建一个train任务得到模型，再使用命令行部署模型，最后再建一个predict任务（带上model_id和model_version）。


* 作业按提交时间入队并以FIFO策略进行调度
* 任务组件
  * 即算法（或算子）
  * 默认的组件Provider在`/python/federatedml/`
  * 自己开发的算法可放到一个文件夹下并先注册为新的组件Provider
  * 每个组件运行完成后保存的模型称为Pipeline模型，在组件运行时定时保存的模型称为Checkpoint模型
* 支持模型整个重跑或从指定组件（因失败或参数更新）开始重跑（需要在DSL中加入callback: ModelCheckpoint）。

### 资源

每个引擎的总资源大小是配置文件配置的（以后会支持自动获取），设计上包括CPU、内存和网络，但目前仅能管理CPU，还不支持GPU。

### 命令行

功能大概可分类如下

* 数据：Data, Table
* 任务：Job, Task
* 结果：Tracking
* 模型：Model, Tag
* 资源：Priviledge, Resource

### 其它

FATE中同时有站点和客户端两个概念，其中客户端通过认证后可以与站点交互，如发布任务和上传数据。

## [FATE Board](https://github.com/FederatedAI/FATE-Board/blob/master/README-CN.md)

可视化FATE Flow中的Job，包括基本信息、组件参数与输出、模型指标与输出、日志、统计图表等。

功能方面界面上只提供任务的取消，其它任务管理仍需要用命令行。


![](https://github.com/FederatedAI/FATE-Board/raw/master/images/dashboard.png)

## [FATE Serving](https://fate-serving.readthedocs.io/en/develop/service/admin/)

从FATE Flow加载模型后对外提供服务，包括单笔预测、多笔预测和多host预测等在线联合预测。

Guest站点需要请求Host站点才能调用到。
