# Limit-rate in Go

A simple practice in learning go.

```go
package main

import "fmt"
import "time"

func RateLimiter(interval time.Duration, size int, callback func(interface{})) chan int {
	reqs := make(chan int, size)
	go func() {
		for req := range reqs {
			callback(req)
			time.Sleep(interval)
		}
	}()

	return reqs
}

func BurstyLimiter(interval time.Duration, size int, callback func(interface{})) chan int {
	tokens := make(chan time.Time, size)
	for i := 0; i < size; i++ {
		tokens <- time.Now()
	}
	go func() {
		for t := range time.Tick(interval) {
			if len(tokens) != size {
				tokens <- t
			}
		}
	}()

	reqs := make(chan int, size)
	go func() {
		for req := range reqs {
			<-tokens
			callback(req)
		}
	}()

	return reqs
}

func main() {
	worker := func(req interface{}) {
		fmt.Println("work is done:", req.(int))
	}
	// limiter := RateLimiter(time.Millisecond*200, 3, worker)
	limiter := BurstyLimiter(time.Millisecond*200, 3, worker)

	for i := 0; i < 5; i++ {
		limiter <- i
	}
	time.Sleep(time.Second * 3)
	for i := 0; i < 5; i++ {
		limiter <- i
	}
	time.Sleep(time.Second * 2)
}
```
