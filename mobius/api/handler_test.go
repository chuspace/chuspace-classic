package api_test

import (
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"testing"

	"github.com/gauravtiwari/chuspace/mobius/api"
)

const storagePath = "/tmp/chuspace"

var (
	ah = api.Handler{}

	apiTests = []struct {
		method  string
		url     string
		handler http.HandlerFunc
		params  string
		status  int
		body    string
	}{
		{"POST", "/init_repo", ah.InitRepo, `{"nickname":"turing","reponame":"turing.chuspace.com"}`, http.StatusNoContent, ""},
	}
)

func TestApiHandler(t *testing.T) {
	os.Setenv("GIT_STORAGE_PATH", storagePath)

	for _, tt := range apiTests {
		t.Run(tt.url, func(t *testing.T) {
			req, err := http.NewRequest(tt.method, tt.url, strings.NewReader(tt.params))
			if err != nil {
				t.Fatal(err)
			}

			rr := httptest.NewRecorder()
			handler := http.HandlerFunc(tt.handler)

			handler.ServeHTTP(rr, req)

			if ct := rr.Header().Get("Content-Type"); ct != "application/json" {
				t.Errorf("Expected content type '%s', got '%s'", "application/json", ct)
			}

			if status := rr.Code; status != tt.status {
				t.Errorf("Expected status '%d', got  '%d'", tt.status, status)
			}

			if rr.Body.String() != tt.body {
				t.Errorf("Expected response '%s', got '%s'", rr.Body.String(), tt.body)
			}

			os.RemoveAll(storagePath)
		})
	}

}
