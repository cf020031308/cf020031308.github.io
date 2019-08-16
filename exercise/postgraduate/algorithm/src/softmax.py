import math

import numpy
import matplotlib.pyplot
import sklearn.datasets


def sigmoid(xw):
    v = math.e ** (xw)
    return (v.T / v.sum(axis=1)).T


def softmax(data, label, lr=1.0, loops=100):
    c = 1 + label.max()
    X = numpy.c_[numpy.ones(data.shape[0]), data]
    Y = numpy.eye(c)[label]
    W = numpy.random.rand(X.shape[1], c)
    for i in range(loops):
        delta = lr * (X.T @ (Y - sigmoid(X @ W))) / X.shape[0]
        delta -= delta[:, 0:1]
        if (delta == 0).all(): break
        W += delta
    return W


def Softmax(*args, **kwargs):
    W = softmax(*args, **kwargs)
    return lambda X: (
        sigmoid(numpy.c_[numpy.ones(X.shape[0]), X] @ W).argmax(axis=1))


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
    classifier = Softmax(data, label)

    x, y = data.T
    _, axes = matplotlib.pyplot.subplots(2)
    gridx, gridy = numpy.meshgrid(
        numpy.arange(x.min(), x.max(), x.ptp() / 200),
        numpy.arange(y.min(), y.max(), y.ptp() / 100))
    gridlabels = (
        classifier(numpy.c_[gridx.ravel(), gridy.ravel()])
        .reshape(gridx.shape))
    axes[0].scatter(x, y, 3, c=label)
    axes[1].pcolormesh(gridx, gridy, gridlabels)
    input()


if __name__ == '__main__':
    main()
