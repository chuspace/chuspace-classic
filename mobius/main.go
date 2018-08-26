package main

import (
	"github.com/gauravtiwari/chuspace/mobius/api"
)

func main() {
	// Run asynchronously because we will also be running SSH/HTTPs servers too
	go func() {
		api.Run()
	}()
}
