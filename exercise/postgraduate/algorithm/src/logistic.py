import numpy
import sklearn.datasets
import matplotlib.pyplot as plt
from softmax import softmax


def main():
    data, label = sklearn.datasets.make_classification(
        n_samples=1000,
        n_features=2,
        n_informative=2,
        n_redundant=0,
        n_classes=2,
        n_clusters_per_class=2,
        weights=[0.3, 0.7],
    )
    w = softmax(data, label)
    b, w0, w1 = w[:, 1] - w[:, 0]

    plt.scatter(*data.T, 3, c=label)
    x = numpy.linspace(data[:, 0].min(), data[:, 0].max())
    plt.plot(x, -(w0 * x + b) / w1, scaley=False)
    input()


if __name__ == '__main__':
    main()
