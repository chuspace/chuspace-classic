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
	ah = api.Router{}

	apiTests = []struct {
		method string
		url    string
		params string
		status int
		body   interface{}
	}{
		{"POST", "/init_repo", `{"nickname":"turing","reponame":"turing.chuspace.com"}`, http.StatusNoContent, ""},
		{"POST", "/init_repo", `{"invalid":"request"}`, http.StatusUnprocessableEntity, nil},
	}
)

func TestRouter(t *testing.T) {
	os.Setenv("GIT_STORAGE_PATH", storagePath)
	router := api.NewRouter()

	for _, tt := range apiTests {
		t.Run(tt.url, func(t *testing.T) {
			req, err := http.NewRequest(tt.method, tt.url, strings.NewReader(tt.params))
			if err != nil {
				t.Fatal(err)
			}

			rr := httptest.NewRecorder()
			router.ServeHTTP(rr, req)

			if ct := rr.Header().Get("Content-Type"); strings.Contains("application/json", ct) {
				t.Errorf("Expected content type '%s', got '%s'", "application/json", ct)
			}

			if status := rr.Code; status != tt.status {
				t.Errorf("Expected status '%d', got  '%d'", tt.status, status)
			}

			if body, ok := tt.body.(string); ok {
				if rr.Body.String() != body {
					t.Errorf("Expected response '%s', got '%s'", rr.Body.String(), tt.body)
				}
			}

			os.RemoveAll(storagePath)
		})
	}

}
