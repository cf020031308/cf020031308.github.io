import math

import numpy
import matplotlib.pyplot
import sklearn.datasets

from softmax import Softmax


def sigmoid(x):
    return 1 / (1 + math.e ** (-x))


class BPNN:
    def __init__(self, shape, train, lr=None, loops=100):
        if not hasattr(lr, '__len__'):
            if lr is None:
                lr = 1.0
            lr = [lr] * (len(shape) - 1)
        assert len(lr) == len(shape) - 1, (
            'Number of Learning rates should be 1 '
            'less than the length of inputs')
        W = [
            numpy.random.rand(x + 1, y)
            for x, y in zip(shape[:-1], shape[1:])]
        data, label = train
        Y = numpy.eye(1 + label.max())[label]
        for i in range(loops):
            flag = False
            for (x, y) in zip(data, Y):
                ins, outs = [], []
                for w in W:
                    x = numpy.r_[1, x]
                    ins.append(x)
                    x = sigmoid(w.T @ x)
                    outs.append(x)
                accum = y - x
                grads = []
                W_ = W[1:] + [numpy.r_[
                    numpy.zeros((1, shape[-1])), numpy.eye(shape[-1])]]
                for x, y, w in list(zip(ins, outs, W_))[::-1]:
                    accum = y * (1 - y) * (w @ accum)[1:]
                    grads.insert(0, numpy.mat(x).T * accum)
                for i in range(len(W)):
                    update = lr[i] * grads[i]
                    if (update == 0).all():
                        continue
                    flag = True
                    W[i] += update
            if not flag:
                break
        self.W = W

    def __call__(self, x):
        y = []
        for v in x:
            for w in self.W:
                v = sigmoid(w.T @ numpy.r_[1, v])
            y.append(v.argmax())
        return numpy.array(y)


def main():
    data, label = sklearn.datasets.make_classification(
        n_samples=1000,
        n_features=2,
        n_informative=2,
        n_redundant=0,
        n_classes=4,
        n_clusters_per_class=1,
        weights=[0.1, 0.2, 0.3, 0.4],
    )
    bpnn0 = BPNN((2, 4), (data, label))
    bpnn1 = BPNN((2, 3, 4), (data, label))
    softmax = Softmax(data, label)

    x, y = data.T
    _, axes = matplotlib.pyplot.subplots(2, 2)
    axes[0][0].set_axis_off()
    axes[0][0].scatter(x, y, 3, c=label)
    gridx, gridy = numpy.meshgrid(
        numpy.arange(x.min(), x.max(), x.ptp() / 200),
        numpy.arange(y.min(), y.max(), y.ptp() / 100))
    for (i, j), classifier, title in (
            ((0, 1), softmax, 'Softmax'),
            ((1, 0), bpnn0, 'No Hidden Layer'),
            ((1, 1), bpnn1, 'One Hidden Layer'),
    ):
        gridlabels = (
            classifier(numpy.c_[gridx.ravel(), gridy.ravel()])
            .reshape(gridx.shape))
        axes[i][j].set_title(title)
        axes[i][j].set_axis_off()
        axes[i][j].pcolormesh(gridx, gridy, gridlabels)
    input()


if __name__ == '__main__':
    main()
