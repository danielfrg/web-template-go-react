package actions

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"strconv"
	"testing"

	"github.com/stretchr/testify/assert"
)

func request(method string, uri string, body *bytes.Buffer) (*httptest.ResponseRecorder, error) {
	router := App()

	if body == nil {
		body = bytes.NewBufferString("")
	}

	req, err := http.NewRequest(method, uri, body)
	if err != nil {
		return nil, err
	}

	rec := httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	return rec, nil
}

func checkStatusOK(t *testing.T, rec *httptest.ResponseRecorder) {
	if rec.Code != http.StatusOK {
		t.Fatalf("expected status OK; got: %v", rec.Code)
	}
}

func TestAddHandler(t *testing.T) {
	rec, _ := request("GET", "/api/v1/add?a=2&b=2", nil)
	checkStatusOK(t, rec)

	res := rec.Result()
	defer res.Body.Close()

	data, err := ioutil.ReadAll(res.Body)
	if err != nil {
		t.Fatalf("Could not read response: %v", err)
	}

	value, err := strconv.Atoi(string(bytes.TrimSpace(data)))
	assert.Equal(t, 4, value, "2+2 should be 4")
}
