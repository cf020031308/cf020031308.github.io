from collections import Counter

import numpy
import sklearn.datasets


def same(v):
    return (v == v[0]).all()


class CART:
    @staticmethod
    def generate_tree(data, label, D, A):
        node = {'most': Counter(label[D]).most_common(1)[0][0]}
        if same(label[D]) or not A.any() or same(data[D].T[A].T):
            node['is_leaf'] = True
            return node

        # Gini Index
        attr = None
        min_gi = numpy.inf
        for atr in numpy.array(range(A.shape[0]))[A]:
            gi = 0
            for v in set(data[D, atr]):
                Dv = D * (data[:, atr] == v)
                ps = numpy.array(list(Counter(label[Dv]).values())) / Dv.sum()
                gi += Dv.sum() * (1 - (ps ** 2).sum())
            gi /= D.sum()
            if gi < min_gi:
                attr = atr
                min_gi = gi

        A[attr] = False
        node.update(
            is_leaf=False,
            attr=attr,
            children={
                v: CART.generate_tree(
                    data, label, D * (data[:, attr] == v), A)
                for v in set(data[D, attr])},
        )
        return node

    def __init__(self, data, label):
        self.tree = self.generate_tree(
            data,
            label,
            numpy.ones(data.shape[0]) == 1,
            numpy.ones(data.shape[1]) == 1,
        )

    def __call__(self, x):
        node = self.tree
        while not node['is_leaf']:
            v = x[node['attr']]
            if v not in node['children']:
                break
            node = node['children'][v]
        return node['most']

    def shrink(self, node=None):
        node = node or self.tree
        if node['is_leaf']:
            return
        for v, sub in list(node['children'].items()):
            self.shrink(sub)
            if sub['is_leaf'] and sub['most'] == node['most']:
                del node['children'][v]
        if not node['children']:
            del node['children']
            del node['attr']
            node['is_leaf'] = True

    def graphviz(self):
        ret = [
            'digraph {',
            'layout="dot";'
        ]
        stack = [(0, self.tree)]
        i = 1
        edges = []
        while stack:
            j, node = stack.pop()
            if node['is_leaf']:
                ret.append('"%s" [label="label: %s"];' % (j, node['most']))
                continue
            ret.append(
                r'"%s" [label="label: %s\nattr: %s"];'
                % (j, node['most'], node['attr']))
            subs = list(enumerate(node['children'].items(), i))
            i += len(subs)
            for k, (v, n) in subs:
                stack.append((k, n))
                edges.append('"%s" -> "%s" [headlabel="%s"];' % (j, k, v))
        ret.extend(edges)
        ret.append('}')
        return '\n'.join(ret)


def main():
    data, label = sklearn.datasets.make_classification(
        n_samples=1000,
        n_features=10,
        n_informative=6,
        n_redundant=2,
        n_classes=4,
        n_clusters_per_class=1,
        weights=[0.1, 0.2, 0.3, 0.4],
    )
    data //= 4
    cart = CART(data, label)
    print(cart.graphviz())
    cart.shrink()
    print(cart.graphviz())


if __name__ == '__main__':
    main()
