import random

import numpy
import sklearn.datasets
import sklearn.model_selection
import matplotlib.pyplot

from utils import dist


class KNN:
    def __init__(self, data, label, k):
        self.data = data
        self.label = label
        self.k = k

    def __call__(self, x):
        counter = numpy.zeros(1 + self.label.max())
        counter[self.label[dist(self.data, x).argsort()[:self.k]]] += 1
        return counter.argmax()


def main():
    k = random.randint(3, 10)
    classes = random.randint(3, 10)
    data, label = sklearn.datasets.make_blobs(
        n_samples=1000, centers=classes, n_features=2)
    knn = KNN(data, label, k)

    x, y = data.T
    _, axes = matplotlib.pyplot.subplots(2)
    axes[0].set_title('Classes: %s, K: %s' % (classes, k))
    gridx, gridy = numpy.meshgrid(
        numpy.arange(x.min(), x.max(), x.ptp() / 200),
        numpy.arange(y.min(), y.max(), y.ptp() / 100))
    gridlabels = (
        numpy.array(list(map(knn, numpy.c_[gridx.ravel(), gridy.ravel()])))
        .reshape(gridx.shape))
    axes[0].scatter(x, y, 3, c=label)
    axes[1].pcolormesh(gridx, gridy, gridlabels)
    input()


if __name__ == '__main__':
    main()
