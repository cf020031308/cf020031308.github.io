ong, X., Choromanski, K., Parker-Holder, J., Tang, Y., Gao, W., Pacchiano, A., ... & Yang, Y. (2019). Reinforcement Learning with Chromatic Networks. arXiv preprint arXiv:1907.06511.

[8] A. Gaier and D. Ha. Weight agnostic neural networks. CoRR, abs/1906.04358, 2019.

The latter paper proposes an extremal approach, where weights are chosen randomly instead of being learned, but the topologies of connections are trained and thus are ultimately strongly biased towards RL tasks under consideration. It was shown in [8] that such weight agnostic neural networks (WANNs) can encode effective policies for several nontrivial RL problems. WANNs replace conceptually simple feedforward networks with general graph topologies using NEAT algorithm providing topological operators to build the network.


The paper Weight Agnostic Neural Networks written by Gaier et la. from Google Brain shows a special result on Network Architecture Search field about how crucial the architecture of a neural network can be and how trivial the weights.
To minimize the importance of weights for a network, researchers measure the performance of it not with the effect of the optimal weights but with the average effect of randomly distributed weights. Thus by randomly evolving from the parent networks with best performance, the children networks can perform better generation by generation with gradually increasing complexity and the constraints that weights do not matter.
Results of this progress, Weight Agnostic Neural Networks (WANNs), can perform as well as traditional networks on several Reinforcement Learning (RL) problems, proving that weights can be much less important than we previously expected.
However, while it indeed stimulates us to think more about the relationship between architectures and weights and inspires us of a new algorithm for finding compact neural networks encoding RL policies, I believe it lacks practicality because the weights are not really dismissed but encoded into the architecture in an inefficient way we may represent an integer with the length of an array.
