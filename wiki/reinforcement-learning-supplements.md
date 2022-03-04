# 学习强化学习过程中的小问题


## 参考书目

* 邹伟《强化学习》
* 周志华《机器学习》中强化学习章节
* 邱锡鹏《神经网络与深度学习》中的强化学习章节
* *Reinforcement Learning: An Introduction* by Richard Sutton


## 𝜖贪心策略改进原始策略的条件


邹伟《蒙特卡罗控制》一章有证明

> “𝜖贪心策略可以改进任意一个给定的策略。”

细看过程似有问题，单看论点也站不住脚：考虑极端情况，假如一个策略本身已是最优的，那么加入随机探索动作后回报只可能减少，遑论改进。


查到Richard Sutton的书里说得清楚

> any ε-greedy policy with respect to $q_\pi$ is an improvement over any ε-soft policy π is assured by the policy improvement theorem


说明了𝜖贪心所改进的原始策略并非任意策略，而是ε-soft的策略。  
而ε-soft policy的定义则要求对每个动作$a \in A$都有$\pi(a|s) \ge \frac{\epsilon}{|A|}$，如此才有
$$ \max\limits_{a} q_\pi(s, a) \ge \sum\limits_{a} [\pi(a|s) - \frac{\epsilon}{|A|}] q_\pi(s, a) $$
（否则大于等于不成立）进而保证改进效果。


直观地理解，一个确定性策略混入概率为ε的探索动作后就是ε-soft的。所以如果称这样的策略为“ε策略”的话，更严谨的说法应该是“𝜖贪心策略可以改进任意𝜖策略”。

## Q-Learning中的Maximization Bias


Double Q-Learning说传统的Q-Learning和DQN都会因为以下更新式中的max而普遍过高估计Q，存在过优化问题
$$Q(s, a) \mathrel{+}= \alpha [r + \gamma \max\limits_{a' \in A} Q(s', a') - Q(s, a)]$$
但为何max操作会导致Maximization Bias？


假设动作值函数已被优化到了一定程度，设为$Q + \epsilon$，其中Q是真实的动作值函数，$\epsilon \sim N(0, 1)$，则
$$\mathbb E_\epsilon[ \max (Q + \epsilon) ] \ge \mathbb E_\epsilon[ Q^* + \epsilon ] = Q^* + \mathbb E\epsilon = Q^* $$
即取max后在期望上会比真实的$ Q^* = \max Q $更大，所以估计会偏大。

## REINFORCE算法中的$\gamma^t$来源


REINFORCE算法的策略函数参数更新方式为
$$\theta \mathrel{+}= \alpha \gamma^t G(\tau_{t:T}) \frac{\partial{}}{\partial{\theta}} \log \pi_\theta(a_t|s_t)$$

更新项为策略梯度中t时刻之后的部分，隐含的意思是t时刻之前的部分期望为0：
$$\mathbb E \sum\limits_{t=0}^{T-1} \frac{\partial{}}{\partial{\theta}} \log \pi_\theta (a_t | s_t) G(\tau_{0:t-1}) = 0$$
如何证明？


该算法后面会学习一个带基线的REINFORCE算法，证明了为策略梯度引入一个和$a_t$无关的基准函数$b(s_t)$后期望不变，即（过程书上有）：
$$\mathbb E b(s_t) \frac{\partial{}}{\partial{\theta}} \log \pi_\theta (a_t | s_t) = 0$$
因为$G(\tau_{0:t-1})$也跟$a_t$无关，所以代入$b(s_t) = G(\tau_{0:t-1})$同理可证。


## 带基线的Reinforce算法中$\alpha = 1$的证明


邱锡鹏书中提供了使用基线可减小REINFORCE算法方差有主要证明（详见我的笔记[方差削减](/wiki/variance-reduction.md)），但取V为基线后就把因子$\alpha$去掉了，为何$\alpha = 1$？


因为$V = \mathbb E_{a} Q$，所以
$$\begin{aligned}
\text{cov}(Q, V) &= \mathbb E_{a, s}(QV) - \mathbb E_{a, s} Q \cdot \mathbb E_{s} V \\\\
&= \mathbb E_{s} V^2 - \mathbb E_{s}^2V \\\\
&= \mathbb DV
\end{aligned}$$
所以$\alpha = \frac{\text{cov}(Q, V)}{\mathbb DV} = 1$
