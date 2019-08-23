import numpy
import matplotlib.pyplot as plt


def PCA(data, dim=2):
    offset = data.mean(axis=0)
    X = data - offset
    values, vectors = numpy.linalg.eig(X.T @ X)
    W = vectors[values.argsort()[-dim:][::-1]]
    Z = X @ W.T
    return Z, Z @ W + offset


def main():
    X = numpy.random.rand(60, 2)
    _, Z = PCA(X, 1)

    plt.scatter(*X.T, color='black')
    plt.scatter(*Z.T, color='red')
    for x, z in zip(X, Z):
        plt.plot([x[0], z[0]], [x[1], z[1]], linestyle='dotted', color='grey')
    input()


if __name__ == '__main__':
    main()
