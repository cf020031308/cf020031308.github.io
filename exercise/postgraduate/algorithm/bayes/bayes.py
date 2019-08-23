import numpy
import sklearn.datasets
import matplotlib.pyplot


class Bayes:
    def __init__(self, data, label):
        n, d = data.shape
        k = label.max() + 1
        fs = [data[:, i].max() + 1 for i in range(d)]
        cs = numpy.array(
            [(label == c).sum() for c in range(k)], dtype=numpy.int64)

        self.py = numpy.ones(k)
        for y in label:
            self.py[y] += 1
        self.py /= (n + k)

        self.pxy = [numpy.ones((f, k)) for f in fs]
        for i, f in enumerate(fs):
            for x, y in zip(data[:, i], label):
                self.pxy[i][x][y] += 1
            self.pxy[i] /= (cs + f)

    def __call__(self, X):
        ret = []
        for x in X:
            p = self.py
            for i, xi in enumerate(x):
                p = p * self.pxy[i][xi]
            ret.append(p.argmax())
        return numpy.array(ret)


def main():
    data, label = sklearn.datasets.make_classification(
        n_samples=100,
        n_features=2,
        n_informative=2,
        n_redundant=0,
        n_classes=4,
        n_clusters_per_class=1,
        weights=[0.1, 0.2, 0.3, 0.4],
    )
    data //= 1
    data[:, 0] -= data[:, 0].min()
    data[:, 1] -= data[:, 1].min()
    data = data.astype(numpy.int64)

    classifier = Bayes(data, label)

    x, y = data.T
    _, axes = matplotlib.pyplot.subplots(2)
    px = numpy.arange(0, x.max() + 1)
    py = numpy.arange(0, y.max() + 1)
    ps = numpy.array([(m, n) for m in px for n in py])
    pl = classifier(ps)
    axes[0].scatter(x, y, 50, c=label)
    axes[1].scatter(*ps.T, 50, c=pl)
    input()


if __name__ == '__main__':
    main()
