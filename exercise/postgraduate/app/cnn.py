import functools

import tensorflow as tf
from tensorflow.examples.tutorials import mnist


w = lambda *shape: tf.Variable(tf.truncated_normal(shape, stddev=0.1))
b = lambda *shape: tf.Variable(tf.constant(0.1, shape=shape))
conv2d = functools.partial(
    tf.nn.conv2d,
    strides=(1, 1, 1, 1), padding='SAME')
maxpool = functools.partial(
    tf.nn.max_pool,
    ksize=(1, 2, 2, 1), strides=(1, 2, 2, 1), padding='SAME')
relu = tf.nn.relu

_ = tf.InteractiveSession()
x = tf.placeholder(tf.float32, (None, 784))
y = tf.placeholder(tf.float32, (None, 10))
keepin = tf.placeholder(tf.float32)

# model
conv1 = maxpool(relu(
    conv2d(tf.reshape(x, (-1, 28, 28, 1)), w(5, 5, 1, 32)) + b(32)))
conv2 = maxpool(relu(conv2d(conv1, w(5, 5, 32, 64)) + b(64)))
full = relu(
    tf.matmul(tf.reshape(conv2, (-1, 7 * 7 * 64)), w(7 * 7 * 64, 1024))
    + b(1024))
drop = tf.nn.dropout(full, keepin)
yhat = tf.nn.softmax(tf.matmul(drop, w(1024, 10)) + b(10))

# loss & strategy
cross_entropy = tf.reduce_mean(
    -tf.reduce_sum(y * tf.log(yhat), reduction_indices=[1]))
train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
tf.global_variables_initializer().run()

# train & validate
acc = tf.reduce_mean(
    tf.cast(tf.equal(tf.argmax(yhat, 1), tf.argmax(y, 1)), tf.float32)
).eval
data = mnist.input_data.read_data_sets('MNIST_data/', one_hot=True)
for i in range(1000):
    feed = dict(zip((x, y), data.train.next_batch(100)))
    if i % 100 == 0:
        feed[keepin] = 1.0
        print('step %d, training accuracy %g' % (i, acc(feed)))
    feed[keepin] = 0.5
    train_step.run(feed)
print(acc({x: data.test.images, y: data.test.labels, keepin: 1.0}))
