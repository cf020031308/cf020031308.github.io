# String Match in Lua VS Ngx


* string.gfind 和 ngx.re.gmatch  
  首先后者不用oj性能比不过前者；然后字符串越简单，前者性能越好。所以看要匹配的字符串是否复杂，可能的分段是否多，越多越复杂越要用ngx，反之用lua。
* string.match 和 ngx.re.match  
  后者性能完爆前者，即使ngx不用oj，lua是plain匹配。所以用ngx。
* string.find 和 ngx.re.find  
  前者如果是模式匹配就非常慢，plain匹配就非常非常快，所以如果是plain匹配的话用lua，模式匹配用ngx。
* ngx.re.find 和 ngx.re.match  
  find快，但快不了那么多
* string.gsub 和 ngx.re.sub/ngx.re.gsub  
  ngx的更快


综上：通常情况下用ngx，非模式匹配地查找字符串用lua，迭代返回字符串中的子串时看复杂度选择。
