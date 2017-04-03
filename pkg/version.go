package pkg

import (
	"fmt"
	"os/exec"
	"strings"
)

// RepoVersion is the string that might be set at compile time to set the binary version
var RepoVersion string

func gitDescribe() string {
	fmt.Println("Executing `git describe` for version in development")

	cmdName := "git"
	cmdArgs := []string{"describe", "--tags", "--always", "--long"}

	var version string
	var cmdOut []byte
	var err error
	if cmdOut, err = exec.Command(cmdName, cmdArgs...).Output(); err != nil {
		version = "<unkown>"
	}
	version = strings.TrimSpace(string(cmdOut))
	return version + "-localdev"
}

// Version returns the version of the project
func Version() string {
	if RepoVersion == "" {
		return gitDescribe()
	}
	return RepoVersion
}
