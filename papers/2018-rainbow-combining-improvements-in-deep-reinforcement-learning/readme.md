引用次数 394

速度、稳定

共同架构：DQN

| 方案                     | 原理                                         | 解决问题                                                      |
|--------------------------|----------------------------------------------|---------------------------------------------------------------|
| Double DQN               | decouple selection and evaluation of actions | overestimation bias                                           |
| Prioritized DDQN         | Prioritized Experience Replay                | data efficiency                                               |
| Dueling Prioritized DDQN | Dueling network arch                         | generalize across actions                                     |
| A3C                      | Multi-step，使用截断的 n 步折扣奖励          | 更快，shift bias-variance trade-off, propagate rewards faster |
| Distributional DQN       | learn distribution of returns                | 随机性?                                                       |
| Noisy DQN                | stochastic network layer                     | exploration                                                   |


Q-learning

$$ \Delta = R_{t+1} + \gamma_{t+1} \max\limits_{a'} q_{\bar{\theta}} (S_{t+1}, a') - q_{\theta} (S_t, A_T) $$

Double Q-learning

$$ \Delta = R_{t+1} + \gamma_{t+1} q_{\bar{\theta}} (S_{t+1}, \argmax\limits_{a'} q_{\theta} (S_{t+1}, a')) - q_{\theta} (S_t, A_T) $$

Prioritized Replay

$$ p_t \propto |\Delta|^\omega $$

Deuling network https://arxiv.org/abs/1511.06581.pdf
