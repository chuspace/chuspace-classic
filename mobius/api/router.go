package api

import (
	"github.com/gin-gonic/gin"
	"net/http"

	"github.com/gauravtiwari/chuspace/mobius/git"
)

type Router struct{}

func NewRouter() *gin.Engine {
	h := Router{}
	r := gin.Default()

	r.POST("/init_repo", h.InitRepo)

	return r
}

func (r *Router) InitRepo(c *gin.Context) {
	json := struct {
		Nickname string `json:"nickname" binding:"required"`
		Reponame string `json:"reponame" binding:"required"`
	}{}

	if err := c.ShouldBindJSON(&json); err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{"error": err.Error()})
		return
	}

	_, err := git.InitBareRepo(json.Nickname, json.Reponame)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
