# 学习强化学习中的小问题

参考的书有

* 邹伟《强化学习》
* 周志华《机器学习》中强化学习章节
* 邱锡鹏《神经网络与深度学习》中的强化学习章节
* *Reinforcement Learning: An Introduction* by Richard Sutton

## 𝜖贪心策略改进原始策略的条件

邹伟有证明“𝜖贪心策略可改进任意策略”，细看公式符号有点糊涂，过程似有问题。最重要的是单看这个论点也是站不住脚的：考虑极端情况，假如一个策略本身已是最优的，那么加入随机探索动作后回报只可能减少，遑论改进。

邱锡鹏没提、周志华带过了这一点，Richard Sutton说得清楚

> any ε-greedy policy with respect to $q_\pi$ is an improvement over any ε-soft policy π is assured by the policy improvement theorem

说明了𝜖贪心所改进的原始策略并非任意策略，而是ε-soft的策略，而ε-soft policy的定义则要求 $\pi(a|s) \ge \frac{\epsilon}{|A|}$，如此才有
$$ \max\limits_{a} q_\pi(s, a) \ge \sum\limits_{a} [\pi(a|s) - \frac{\epsilon}{|A|}] q_\pi(s, a) $$
进而保证改进效果。

如何直观地理解ε-soft？其实，一个确定性策略混入概率为ε的探索动作后就是ε-soft的。那如果称这样的策略为“ε策略”的话，更严谨的说法应该是“𝜖贪心策略可以改进任意𝜖策略”。

## Q-Learning中的Maximization Bias

Double Q-Learning说传统的Q-Learning和DQN都会普遍过高估计Q，存在过优化问题。但几本书都没详细解释为何max操作会导致Maximization Bias，这一点可能需要看原论文。

自己推了下：假设Q已被优化到了一定程度，设已经为$Q + \epsilon$，其中Q是真实值函数，$\epsilon \sim N(0, 1)$，则$E_\epsilon[ \max (Q + \epsilon) ] \ge E_\epsilon[Q^* + \epsilon] = Q^* + E\epsilon = Q*$，即取max后在期望上会比真实的max Q更大，所以估计会偏大。

## Reinforce算法中的$\gamma^t$没有说清楚

邹伟只说是用来修饰步长的，步长要越来越小，比较表面。邱锡鹏有推导，但关键一步没看懂，作为习题且答案略。

用邱锡鹏的符号表示就是要证明
$$E \sum\limits_{t=0}^{T-1} \frac{\partial{}}{\partial{\theta}} \log \pi_\theta (a_t | s_t) G(\tau_{0:t-1}) = 0$$

可以套用后面加入基线不改变期望的证明，因为$G(\tau_{0:t-1})$也跟$a_t$无关，所以把证明过程中的基线换过来就同理可得
$$E \frac{\partial{}}{\partial{\theta}} \log \pi_\theta (a_t | s_t) G(\tau_{0:t-1}) = 0$$

## Reinforce算法带基线能减少方差的证明

周志华没涉及这部分，邹伟和Richard Sutton证明了加入基线不改变估计的期望（无偏），但只较intuitive地说加基线可以减少方差（确实直觉也很好理解），草草翻了下该方法的论文看不出所以然。

邱锡鹏提供了证明，见我的笔记[方差削减](/wiki/variance-reduction.md)，但选完基线就把因子$\alpha$扔了，自己大致证明因为$V = EQ$所以$\text{cov}(Q, V) = E(QV) - EQ \cdot EV = EV^2 - E^2V = DV$所以$\alpha = 1$。

## TRPO和DDPG

没看懂，换书且以后再说
