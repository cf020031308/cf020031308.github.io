# Speedup the Pipeline in Redis-py

Using `pipeline`s is a way to speedup the execution of `redis` commands when you use `redis-py` library in `python` script.

**But what if the `pipeline` is not able to finish commands in time either?**

Internally, the `redis` server accepts commands from clients and executes them. Then it puts the response in a queue and waits for the clients to fetch.

So a proper client should read the response once it sends commands.

That's why a `pipeline` is still slow: it not only sends commands, but also waits and reads the response and parse it. And the latter procedure costs 60% time.

### Solution 1: Hiredis

`hiredis` is a parser written in `C`, which is extremely fast and it reduces 50% time the whole pipeline costs. 

The Installation is easy:

    pip install hiredis

Nothing else needs to be done. The `redis-py` will automatically use `hiredis` as the response parser if it's installed.

### Solution 2: Ignore the response

This is nearly a black magic. If you need to keep it transactional or you want to get the response, do not use this method.

```python
pipeline = redis_client.pipeline(transaction=False)
# several pipeline commands: bla bla bla
pipeline.command_stack = iter(pipeline.command_stack)
pipeline.execute()
```

But remember, the response never disappears but stays in the response queue in the server. So if you need to execute a query command later, such as `HGET`, you must first disconnect the client to force the server to clean the cache and then reconnect to the server to query. Otherwise you'll get the queued response responding the pipeline commands.

Even if there's nothing to query, you have to reconnect `redis` to release the memory used by the cached responses. Otherwise the used memory of the server will keep increasing till crashing.

Here's the way to reconnect:

```python
redis_client.connection_pool.disconnect()
redis_client = get_redis_client()
```

So you may use a diy client like this:

```python
class RedisClient(object):
    def __init__(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs
        self.rd = redis.Redis(*args, **kwargs)
        self.rd4pp = None
        self.default_sock_stack = 0
        self.sock_stack = self.default_sock_stack

    def __getattr__(self, attr):
        return self.rd.__getattribute__(attr)
    
    def connect(self):
        try:
            self.rd4pp.connection_pool.disconnect()
        except:
            pass
        self.rd4pp = redis.Redis(*self.args, **self.kwargs)
        self.sock_stack = self.default_sock_stack

    def pipeline(self, transaction=False):
        if transaction:
            return self.rd.pipeline(transaction=True)
            
        pp = self.rd4pp.pipeline(transaction=False)
        exe = pp.execute

        def execute():
            if self.sock_stack <= 0:
                self.connect()
            pp.command_stack = iter(pp.command_stack)
            exe()
            self.sock_stack -= 1
            return []
            
        pp.execute = execute
        return pp
```

### Solution 3: Use the protocol, Luke

Take look at this article [Redis Mass Insertion](http://redis.io/topics/mass-insert) from `redis.io` first and then you'll know we can simply use `socket` to do mass insertion at a holy high speed: at least 3 times faster than Solution 2.

```python
def connect(self, host='localhost', port=6379, db=0, password=None,
            *args, **kwargs):
    try:
        self.rd4pp.close()
    except:
        pass
    self.rd4pp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.rd4pp.connect((host, port))
    if password:
        self.rd4pp.send(
            '*2\r\n$4\r\nAUTH\r\n$%s\r\n%s\r\n'
            % (len(password), password))
    if db:
        self.rd4pp.send(
            '*2\r\n$6\r\nSELECT\r\n$%s\r\n%s\r\n' % (len(db), db))
    self.sock_stack = self.default_sock_stack
    
def pipeline(self, transaction=False):
    pp = self.rd.pipeline(transaction=transaction)
    if transaction:
        return pp
    exe = pp.execute
        
    def execute():
        if self.sock_stack < 0:
            self.connect(*self.args, **self.kwargs)
        self.rd4pp.send(''.join(
            '*%s\r\n' % len(cmd)
            + ''.join(['$%s\r\n%s\r\n' % (len(str(w)), w) for w in cmd])
            for cmd, _ in pp.command_stack))
        pp.command_stack = []
        self.sock_stack -= 1
        return []
        
    pp.execute = execute
    return pp
```

## [Comment Here](https://github.com/cf020031308/cf020031308.github.io/issues/12)
