package version

import (
	"fmt"
	"io/ioutil"
	"os/exec"
	"strings"
)

// VERSION indicates which version of the binary is running.
var VERSION string

// GITCOMMIT indicates which git hash the binary was built of.
var GITCOMMIT string

type version struct {
	Version   string `json:"version"`
	GitCommit string `json:"gitcommit"`
}

func getVersion() string {
	version, err := ioutil.ReadFile("./VERSION.txt")
	if err != nil {
		return "<unknown>"
	}
	return strings.TrimSpace(string(version)) + "-localdev"
}

// This allows us to get this even with no
func getGitCommit() string {
	fmt.Println("Executing `git rev-parse --short HEAD` just for dev")

	cmdName := "git"
	cmdArgs := []string{"rev-parse", "--short", "HEAD"}

	var commit string
	var cmdOut []byte
	var err error
	if cmdOut, err = exec.Command(cmdName, cmdArgs...).Output(); err != nil {
		commit = "<unknown>"
	}
	commit = strings.TrimSpace(string(cmdOut))
	return commit
}

// Version returns the version struct of the project
func Version() version {
	ver := VERSION
	if VERSION == "" {
		ver = getVersion()
	}

	commit := GITCOMMIT
	if VERSION == "" {
		commit = getGitCommit()
	}

	return version{ver, commit}
}
