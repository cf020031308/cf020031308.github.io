import time
import datetime

import numpy
import tensorflow as tf


def collect(lst):
    def deco(func):
        def wrapper(*args, **kwargs):
            v = func(*args, **kwargs)
            lst.append(v)
            return v
        return wrapper
    return deco


def print_activations(t):
    print(t.op.name, t.get_shape().as_list())


def inference(images):
    params = []
    w = collect(params)(lambda *shape: tf.Variable(
        tf.truncated_normal(shape, dtype=tf.float32, stddev=0.1),
        name='weights'))
    b = collect(params)(lambda *shape: tf.Variable(
        tf.constant(0.0, shape=shape, dtype=tf.float32),
        trainable=True,
        name='biases'))

    conv_confs = [
        [(11, 11), 64, (4, 4), True, True],
        [(5, 5), 192, (1, 1), True, True],
        [(3, 3), 384, (1, 1), False, False],
        [(3, 3), 256, (1, 1), False, False],
        [(3, 3), 256, (1, 1), False, True],
    ]
    tensor = images
    for i, conv_conf in enumerate(conv_confs, 1):
        with tf.name_scope('conv%d' % i) as scope:
            size, count, strides, lrn, pool = conv_conf
            tensor = tf.nn.relu(
                tf.nn.bias_add(
                    tf.nn.conv2d(
                        tensor,
                        w(*size, tensor.get_shape().as_list()[-1], count),
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
                tf.matmul(tensor, w(insize, outsize)) + b(outsize),
                name=scope)
            insize = outsize

    with tf.name_scope('softmax') as scope:
        outsize = 1000
        yhat = tf.nn.softmax(
            tf.matmul(tensor, w(insize, outsize)) + b(outsize))

    return yhat, params


def timeit(session, target, info, num_batches=100):
    durations = []

    for i in range(-10, num_batches):
        start_time = time.time()
        _ = session.run(target)
        duration = time.time() - start_time
        if i < 0:
            continue
        if not i % 10:
            print('%s: step %d, duration = %.3f'
                  % (datetime.datetime.now(), i, duration))
        durations.append(duration)

    durations = numpy.array(durations)
    print('%s: %s across %d steps, %.3f ± %.3f sec / batch' % (
        datetime.datetime.now(),
        info,
        num_batches,
        durations.mean(),
        durations.std()))


def benchmark(batch_size=16):
    with tf.Graph().as_default():
        images = tf.Variable(tf.random.normal(
            (batch_size, 224, 224, 3),
            dtype=tf.float32,
            stddev=1e-1))
        alexnet, params = inference(images)
        init = tf.global_variables_initializer()
        session = tf.Session()
        session.run(init)

        timeit(session, alexnet, 'Forward')

        grad = tf.gradients(tf.nn.l2_loss(alexnet), params)
        timeit(session, grad, 'Forward-backward')


if __name__ == '__main__':
    benchmark()
