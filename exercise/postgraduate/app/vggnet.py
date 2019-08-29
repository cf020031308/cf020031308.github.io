import numpy
import tensorflow as tf

from utils import collect, timeit, init_session


def inference(tensor, keepin):
    params = []
    w = collect(params)(lambda *shape, **kw: tf.get_variable(
        kw.pop('scope', '') + 'w',
        shape=shape,
        dtype=tf.float32,
        initializer=tf.contrib.layers.xavier_initializer_conv2d(),
    ))
    b = collect(params)(lambda *shape, **kw: tf.Variable(
        tf.constant(kw.pop('init', 0.0), shape=shape, dtype=tf.float32),
        name='b',
        **kw))

    convs_confs = [
        [
            [(3, 3), 64, (1, 1)],
            [(3, 3), 64, (1, 1)],
        ],
        [
            [(3, 3), 128, (1, 1)],
            [(3, 3), 128, (1, 1)],
        ],
        [
            [(3, 3), 256, (1, 1)],
            [(3, 3), 256, (1, 1)],
            [(3, 3), 256, (1, 1)],
        ],
        [
            [(3, 3), 512, (1, 1)],
            [(3, 3), 512, (1, 1)],
            [(3, 3), 512, (1, 1)],
        ],
        [
            [(3, 3), 512, (1, 1)],
            [(3, 3), 512, (1, 1)],
            [(3, 3), 512, (1, 1)],
        ],
    ]
    for i, convs_conf in enumerate(convs_confs, 1):
        for j, conv_conf in enumerate(convs_conf, 1):
            with tf.name_scope('conv%d_%d' % (i, j)) as scope:
                size, count, strides = conv_conf
                tensor = tf.nn.relu(
                    tf.nn.bias_add(
                        tf.nn.conv2d(
                            tensor,
                            w(*size, tensor.get_shape().as_list()[-1], count,
                              scope=scope),
                            (1, *strides, 1),
                            padding='SAME'),
                        b(count, trainable=True)),
                    name=scope)
        tensor = tf.nn.max_pool(
            tensor,
            ksize=(1, 2, 2, 1),
            strides=(1, 2, 2, 1),
            padding='SAME',
            name='pool%d')

    insize = numpy.array(tensor.get_shape().as_list()[1:]).prod()
    tensor = tf.reshape(tensor, (-1, insize))
    for i, outsize in enumerate([4096, 4096, 1000], i + 1):
        with tf.name_scope('fc%d' % i) as scope:
            tensor = tf.nn.relu(
                tf.matmul(tensor, w(insize, outsize, scope=scope))
                + b(outsize),
                name=scope)
            if outsize == 1000:
                tensor = tf.nn.softmax(tensor)
            else:
                tensor = tf.nn.dropout(tensor, keepin, name=scope + '_drop')
            insize = outsize

    return tensor, params


def benchmark(batch_size=8):
    with tf.Graph().as_default():
        images = tf.Variable(tf.random.normal(
            (batch_size, 224, 224, 3),
            dtype=tf.float32,
            stddev=1e-1))
        keepin = tf.placeholder(tf.float32)
        cnn, params = inference(images, keepin)
        session = init_session()

        num_batches = 30
        timeit(
            session, cnn, 'Forward',
            feed={keepin: 1.0}, num_batches=num_batches)

        grad = tf.gradients(tf.nn.l2_loss(cnn), params)
        timeit(
            session, grad, 'Forward-backward',
            feed={keepin: 0.5}, num_batches=num_batches)


if __name__ == '__main__':
    benchmark()
