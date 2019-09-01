import string

import tensorflow as tf

from utils import timeit, init_session


slim = tf.contrib.slim
trunc_normal = tf.truncated_normal_initializer


def kernel(kset, **kw):
    'e.g. 1a_conv32_1x1/2_VALID'
    key, comp, *rest = kset.split('_')
    comp = comp.lower()
    if '/' not in kset:
        kw.setdefault('stride', 1)
        size = rest[0]
    else:
        size, kw['stride'] = rest[0].split('/')
        if len(rest) > 1:
            kw['padding'] = rest[1]
    size = tuple(map(int, size.split('x')))
    kw['stride'] = int(kw['stride'])
    if 'padding' in kw:
        kw['padding'] = kw['padding'].upper()

    if comp.startswith('conv'):
        kw = dict({
            'weights_regularizer': slim.l2_regularizer(4e-5),
            'weights_initializer': trunc_normal(0.1),
            'activation_fn': tf.nn.relu,
            'normalizer_fn': slim.batch_norm,
            'normalizer_params': {
                'decay': 0.9997,
                'epsilon': 0.001,
                'updates_collections': tf.GraphKeys.UPDATE_OPS,
                'variables_collections': {
                    'beta': None,
                    'gamma': None,
                    'moving_mean': ['moving_vars'],
                    'moving_variance': ['moving_vars'],
                },
            },
        }, **kw)
        return lambda t: slim.conv2d(t, int(comp[4:]), size, scope=kset, **kw)

    return lambda t: {
        'maxpool': slim.max_pool2d,
        'avgpool': slim.avg_pool2d,
    }[comp](t, size, scope=kset, **kw)


def inference(
        tensor,
        n_classes=1000,
        dropout_keep=0.8,
        prediction_fn=slim.softmax,
        spatial_squeeze=True,
        reuse=None,
        scope='InceptionV3'):
    halfnet = None
    with tf.variable_scope(
            scope, 'InceptionV3', [tensor, n_classes], reuse=reuse):
        # Compress to 35x35x192 from 299x299x3
        for kset in [
                '1a_conv32_3x3/2_valid',
                '2a_conv32_3x3/1_valid',
                '2b_conv64_3x3/1_same',
                '3a_maxpool_3x3/2_valid',
                '3b_conv80_1x1/1_valid',
                '4a_conv192_3x3/1_valid',
                '5a_maxpool_3x3/2_valid',
        ]:
            tensor = kernel(kset)(tensor)

        # Transform pixels into channels
        kw = {'stride': 1, 'padding': 'SAME'}
        for i, inception in enumerate([
                [
                    [],
                    [
                        '0a_conv64_1x1',
                        '0a_conv48_1x1 0b_conv64_5x5',
                        '0a_conv64_1x1 0b_conv96_3x3 0c_conv96_3x3',
                        '0a_avgpool_3x3 0b_conv32_1x1',
                    ],
                    [
                        '0a_conv64_1x1',
                        '0b_conv48_1x1 0c_conv64_5x5',
                        '0a_conv64_1x1 0b_conv96_3x3 0c_conv96_3x3',
                        '0a_avgpool_3x3 0b_conv64_1x1',
                    ],
                    [
                        '0a_conv64_1x1',
                        '0a_conv48_1x1 0b_conv64_5x5',
                        '0a_conv64_1x1 0b_conv96_3x3 0c_conv96_3x3',
                        '0a_avgpool_3x3 0b_conv64_1x1',
                    ]
                ],
                [
                    [
                        '1a_conv384_3x3/2_valid',
                        '0a_conv64_1x1 0b_conv96_3x3 1a_conv96_3x3/2_valid',
                        '1a_maxpool_3x3/2_valid',
                    ],
                    [
                        '0a_conv192_1x1',
                        # Factorization into small convolutions
                        '0a_conv128_1x1 0b_conv128_1x7 0c_conv192_7x1',
                        '0a_conv128_1x1 0b_conv128_7x1 0c_conv128_1x7 0d_conv128_7x1 0e_conv192_1x7',
                        '0a_avgpool_3x3 0b_conv192_1x1',
                    ],
                    [
                        # Simple Abstraction
                        '0a_conv192_1x1',
                        # Complex Abstractions
                        '0a_conv160_1x1 0b_conv160_1x7 0c_conv192_7x1',
                        '0a_conv160_1x1 0b_conv160_7x1 0c_conv160_1x7 0d_conv160_7x1 0e_conv192_1x7',
                        # Simple Pooling
                        '0a_avgpool_3x3 0b_conv192_1x1',
                    ],
                    [
                        '0a_conv192_1x1',
                        '0a_conv160_1x1 0b_conv160_1x7 0c_conv192_7x1',
                        '0a_conv160_1x1 0b_conv160_7x1 0c_conv160_1x7 0d_conv160_7x1 0e_conv192_1x7',
                        '0a_avgpool_3x3 0b_conv192_1x1',
                    ],
                    [
                        '0a_conv192_1x1',
                        '0a_conv192_1x1 0b_conv192_1x7 0c_conv192_7x1',
                        '0a_conv192_1x1 0b_conv192_7x1 0c_conv192_1x7 0d_conv192_7x1 0e_conv192_1x7',
                        '0a_avgpool_3x3 0b_conv192_1x1',
                    ]
                ],
                [
                    [
                        '0a_conv192_1x1 1a_conv320_3x3/2_valid',
                        '0a_conv192_1x1 0b_conv192_1x7 0c_conv192_7x1 1a_conv192_3x3/2_valid',
                        '1a_maxpool_3x3/2_valid',
                    ],
                    [
                        '0a_conv320_1x1',
                        '0a_conv384_1x1 0b_conv384_1x3+0c_conv384_3x1',
                        '0a_conv448_1x1 0b_conv384_3x3 0c_conv384_1x3+0d_conv384_3x1',
                        '0a_avgpool_3x3 0b_conv192_1x1',
                    ],
                    [
                        '0a_conv320_1x1',
                        '0a_conv384_1x1 0b_conv384_1x3+0c_conv384_3x1',
                        '0a_conv448_1x1 0b_conv384_3x3 0c_conv384_1x3+0d_conv384_3x1',
                        '0a_avgpool_3x3 0b_conv192_1x1',
                    ],
                ],
        ], 5):
            for c, mixed in zip(string.ascii_lowercase, inception):
                with tf.variable_scope('Mixed_%d%s' % (i, c)):
                    branches = []
                    for j, branch in enumerate(mixed):
                        with tf.variable_scope('Branch_%d' % j):
                            bch = tensor
                            for kset in branch.split():
                                if '+' in kset:
                                    bch = tf.concat([
                                        kernel(ks, **kw)(bch)
                                        for ks in kset.split('+')], 3)
                                else:
                                    bch = kernel(kset, **kw)(bch)
                            branches.append(bch)
                    if branches:
                        tensor = tf.concat(branches, 3)
                    if (i, c) == (6, 'e'):
                        halfnet = tensor

        with tf.variable_scope('AuxLogits'):
            for kset, kw in [
                    ('1a_avgpool_5x5/3_valid', {}),
                    ('1b_conv128_1x1/1_same', {}),
                    ('2a_conv768_5x5/1_valid', {
                        'weights_initializer': trunc_normal(0.01)}),
                    ('2b_conv%s_1x1/1_same' % n_classes, {
                        'activation_fn': None,
                        'normalizer_fn': None,
                        'weights_initializer': trunc_normal(0.001)}),
            ]:
                halfnet = kernel(kset, **kw)(halfnet)
            if spatial_squeeze:
                halfnet = tf.squeeze(halfnet, (1, 2), name='SpatialSqueeze')

        with tf.variable_scope('Logits'):
            tensor = kernel('1a_avgpool_8x8/1_valid')(tensor)
            tensor = slim.dropout(
                tensor, keep_prob=dropout_keep, scope='Dropout_1b')
            logits = kernel(
                '1c_conv%s_1x1/1_same' % n_classes,
                activation_fn=None,
                normalizer_fn=None
            )(tensor)
            logits = tf.squeeze(logits, (1, 2), name='SpatialSqueeze')

        predictions = prediction_fn(logits, scope='Predictions')

        return {
            'AuxLogits': halfnet,
            'PreLogits': tensor,
            'Logits': logits,
            'Predictions': predictions,
        }


def benchmark(batch_size=8):
    # with tf.Graph().as_default():
    images = tf.Variable(tf.random.uniform((batch_size, 299, 299, 3)))
    with slim.arg_scope([slim.batch_norm, slim.dropout], is_training=False):
        endpoints = inference(images)
    session = init_session()
    timeit(session, endpoints['Logits'], 'Forward', num_batches=10)


if __name__ == '__main__':
    benchmark()
