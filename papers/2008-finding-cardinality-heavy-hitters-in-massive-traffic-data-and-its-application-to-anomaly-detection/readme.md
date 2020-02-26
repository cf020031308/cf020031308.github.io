# 韩信

就是我 2015 年在创宇时做一个流计算需求时想做的东西。

用 count-min sketch 的方式将一个键哈希到多个 HyperLogLog 处，把其下事件放进 HyperLogLog。

统计时各 HyperLogLog 对应桶先取最小，再一起估算基数。

以此估算一个大数据环境下事件基数最多的键。
