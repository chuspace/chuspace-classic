package api

import (
	"fmt"
	"net/http"
	"os"
)

// something
func Run() error {
	router := NewRouter()
	port := fmt.Sprintf(":%s", os.Getenv("API_PORT"))
	return http.ListenAndServe(port, router)
}
