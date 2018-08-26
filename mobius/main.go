package main

import (
	"github.com/gauravtiwari/chuspace/mobius/api"
	"github.com/gauravtiwari/chuspace/mobius/ssh"
	"log"
	"sync"
)

func main() {
	wg := &sync.WaitGroup{}

	wg.Add(1)
	go func() {
		log.Println("Starting HTTP API...")
		log.Fatal(api.Run())
		wg.Done()
	}()

	wg.Add(1)
	go func() {
		log.Println("Starting SSH server...")
		log.Fatal(ssh.Run())
		wg.Done()
	}()

	wg.Wait()
}
