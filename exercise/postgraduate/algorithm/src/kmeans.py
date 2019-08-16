import random

import numpy
import sklearn.datasets
import matplotlib.pyplot as plt

from utils import dist


def kmeans(data, k, target_diff=1):
    assert len(data) >= k, 'Dataset size is smaller than k.'
    centers = numpy.array(random.sample(list(data), k))
    while 1:
        sets = [[] for i in range(k)]
        for x in data:
            sets[dist(centers, x).argmin()].append(x)
        sets = [numpy.array(s) for s in sets]

        new_centers = numpy.array([s.mean(axis=0) for s in sets])
        if dist(new_centers - centers, 0).sum() < target_diff:
            return sets
        centers = new_centers


def main():
    k = random.randint(3, 10)
    clusters = random.randint(3, 10)
    data, _ = sklearn.datasets.make_blobs(
        n_samples=1000, centers=clusters, n_features=2)
    plt.title('Clusters: %s, K: %s' % (clusters, k))
    for cluster in kmeans(data, k):
        plt.scatter(cluster[:, 0], cluster[:, 1], 3)
    input()


if __name__ == '__main__':
    main()
