package api

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func Server() {
	s := gin.Default()

	repo := s.Group("/repo")
	{
		repo.POST("/", createNewRepo)
	}
}

func createNewRepo() {

}
