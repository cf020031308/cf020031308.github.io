import numpy
import tensorflow as tf

from utils import collect, print_activations, timeit, init_session


def inference(tensor):
    params = []
    w = collect(params)(lambda *shape: tf.Variable(
        tf.truncated_normal(shape, dtype=tf.float32, stddev=0.1),
        name='weights'))
    b = collect(params)(lambda *shape, **kw: tf.Variable(
        tf.constant(kw.get('init', 0.0), shape=shape, dtype=tf.float32),
        trainable=True,
        name='biases'))

    conv_confs = [
        [(11, 11), 64, (4, 4), True, True],
        [(5, 5), 192, (1, 1), True, True],
        [(3, 3), 384, (1, 1), False, False],
        [(3, 3), 256, (1, 1), False, False],
        [(3, 3), 256, (1, 1), False, True],
    ]
    for i, conv_conf in enumerate(conv_confs, 1):
        with tf.name_scope('conv%d' % i) as scope:
            size, count, strides, lrn, pool = conv_conf
            tensor = tf.nn.relu(
                tf.nn.bias_add(
                    tf.nn.conv2d(
                        tensor,
                        w(*size, tensor.get_shape()[-1].value, count),
                        (1, *strides, 1),
                        padding='SAME'),
                    b(count)),
                name=scope)
            print_activations(tensor)

            if lrn:
                tensor = tf.nn.lrn(
                    tensor, 4, alpha=1e-3/9, beta=0.75, name='lrn%d' % i)

            if pool:
                strides = (2, 2)
                tensor = tf.nn.max_pool(
                    tensor,
                    ksize=(1, 3, 3, 1),
                    strides=(1, *strides, 1),
                    padding='VALID',
                    name='pool%d' % i)
                print_activations(tensor)

    insize = numpy.array(tensor.get_shape().as_list()[1:]).prod()
    tensor = tf.reshape(tensor, (-1, insize))
    for i, outsize in enumerate([4096, 4096, 1000], i + 1):
        with tf.name_scope('full%d' % i) as scope:
            tensor = tf.nn.relu(
                tf.matmul(tensor, w(insize, outsize)) + b(outsize, init=0.1),
                name=scope)
            insize = outsize
            if outsize == 1000:
                tensor = tf.nn.softmax(tensor)

    return tensor, params


def benchmark(batch_size=16):
    with tf.Graph().as_default():
        images = tf.Variable(tf.random.normal(
            (batch_size, 224, 224, 3),
            dtype=tf.float32,
            stddev=1e-1))
        cnn, params = inference(images)
        session = init_session()

        num_batches = 50
        timeit(session, cnn, 'Forward', num_batches=num_batches)

        grad = tf.gradients(tf.nn.l2_loss(cnn), params)
        timeit(session, grad, 'Forward-backward', num_batches=num_batches)


if __name__ == '__main__':
    benchmark()
