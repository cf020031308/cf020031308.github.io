# I Don't Want to Teach my Garbage DSL, either

Once at Knownsec one of my tasks was to maintain and develop APIs to provide real-time logs and aggregation data. So as time went by I developed something I called `v2`.

The main feature of it was to power frontend developers with a self-designed-formatted URL as a Query Language.  
When the API server received an HTTP Get request, it converted the URL into specific query languages for backend databases such as ElasticSearch, Redis and influxDB.  
Once the server collected all the returned data from related databases after dispatching the query languages, it packed them up in a unified format and sent it to the front.

In this way, the frontend developers could query almost anything without waiting for a new interface. And all the interfaces and returned data became unified.  
Other backend developers could supply new kind of data by simply adding configurations, without the care of where the data was and how the data was organized.
I could develop new global features plugin by plugin, such as authorization, cache, and error handling since everything was abstracted and organized layer by layer.

I thought it was perfect. So with these pros and the summed up cons, I began to develop the next version.

It took me a long time. During it I read an article [I don't want to learn your garbage query language](https://erikbern.com/2018/08/30/i-dont-want-to-learn-your-garbage-query-language.html), which pointed out something I hadn't realized but something started to emerge.

Because of the early use of ElasticSearch, DSL was well accepted among my colleagues. So despite the good abstraction, what I reinvented was actually just another DSL. But it turned out to be really expensive for one to design and implement a DSL, especially to put it into practice.

A better way is to use SQL, by leveraging open-sourced projects such as [elasticsearch-sql](https://github.com/NLPchina/elasticsearch-sql). It may be lower in performance. It may be inconvenient than HTTP Get. But it is cheap.

## [Comment](https://github.com/cf020031308/cf020031308.github.io/issues/14)
