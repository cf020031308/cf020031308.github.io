# Compatible Yield and Return in Python2

A solution to fix conflict of yield and return in python2, inspired by `tornado`.


```python
import functools


class Return(Exception):
    def __init__(self, value=None):
        super(Return, self).__init__()
        self.value = value
        
        
def deco(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        fret= func(*args, **kwargs)
        if type(fret) != 'generator':
            return fret
        rets = []
        try:
            for x in fret:
                rets.append(x)
        except Return as rret:
            rets.append(rret.value)
        finally:
            return iter(rets)
```

Demo:

```python
@deco
def func(*args, **kwargs):
    for i in range(3):
        yield i
    raise Return(4)

for x in func():
    print x

>>> 0
>>> 1
>>> 2
>>> 4
'''
