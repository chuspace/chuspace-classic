package ssh

import (
	"fmt"
	"github.com/gliderlabs/ssh"
	"io"
	"os"
)

func Run() error {
	ssh.Handle(func(s ssh.Session) {
		io.WriteString(s, "Yo dawg\n")
	})

	port := fmt.Sprintf(":%s", os.Getenv("SSH_PORT"))
	return ssh.ListenAndServe(port, nil)
}
