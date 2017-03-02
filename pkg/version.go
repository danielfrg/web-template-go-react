package pkg

import (
	"fmt"
	"strings"
	"os/exec"
)

// This might be set at compile time to set the binary version
var RepoVersion string

func git_describe() string {
	fmt.Println("Executing `git describe` for version in development")

	cmdName := "git"
	cmdArgs := []string{"describe", "--tags", "--always", "--long"}

	var version string
	var cmdOut []byte
	var err    error
	if cmdOut, err = exec.Command(cmdName, cmdArgs...).Output(); err != nil {
		version = "<unkown>"
	}
	version = strings.TrimSpace(string(cmdOut))
	return version + "-localdev"
}

func Version() string {
	if RepoVersion == "" {
	    return git_describe()
	}
	return RepoVersion
}
