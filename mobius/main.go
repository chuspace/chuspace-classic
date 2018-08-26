package main

import (
	"fmt"
	"github.com/gauravtiwari/chuspace/api"
)

func main() {
	// Run asynchronously because we will also be running SSH/HTTPs servers too
	go func() {
		api.Run()
	}()
}
