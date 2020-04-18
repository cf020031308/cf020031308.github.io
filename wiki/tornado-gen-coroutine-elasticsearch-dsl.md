# tornado.gen.coroutine with elasticsearch_dsl

A simple way to hack into python-lib `elasticsearch_dsl` and make `class Search` compatible with `tornado.gen.coroutine`:

```python
import tornado.gen
import tornado.httpclient
from elasticsearch_dsl import Search, result


class Search(Search):
    ''' elasticsearch executing in tornado. DO NOT use scan().
    usage:
        class MyHandler(tornado.web.RequestHandler):
            @tornado.gen.coroutine
            def get(self):
                search = Search(using=es, index=idnex).query(
                    'term', host='jd.com')
                ret = yield search.execute()
                self.write(ret.to_dict())
    '''
    SEARCH_PATTERN = ('%(scheme)s://%(http_auth)s@%(host)s:%(port)s'
                      '/%(index)s/%(doc_type)s_search')
                      
    @tornado.gen.coroutine
    def execute(self):
        ret = '{}'
        try:
            url = Search.SEARCH_PATTERN % dict(
                self._using.transport.hosts[0],
                index=','.join(self._index) or '_all',
                doc_type=((','.join(self._doc_type) + '/')
                          if self._doc_type else ''))
            body = json.dumps(self.to_dict())
        except:
            pass
        
        resp = yield tornado.httpclient.AsyncHTTPClient().fetch(
            url, method='POST', body=body)
        ret = resp.body or ret
        
        raise tornado.gen.Return(result.Response(json.loads(ret)))
```

However about the concurrency in `tornado`, my advice is:

> 原型部署一时爽，异步改造火葬场。
> flask大法好，退tornado保平安。
