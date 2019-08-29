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


def timeit(
        session, target, info,
        feed=None, num_batches=100, num_steps_burn_in=10):
    durations = []

    for i in range(-num_steps_burn_in, num_batches):
        start_time = time.time()
        _ = session.run(target, feed)
        duration = time.time() - start_time
        if i < 0:
            continue
        if not (i % (1 + num_batches // 11)):
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


def init_session():
    init = tf.global_variables_initializer()
    session = tf.Session()
    session.run(init)
    return session
