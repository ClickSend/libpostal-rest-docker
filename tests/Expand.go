package main

import (
	"fmt"
	"net/http"
	"net/url"
)

// Expand returns expanded postal address submitted.
func Expand() int {
	// Test query body
	resp, err := http.PostForm("http://localhost:8080/expand", url.Values{"query": {"100 main st buffalo ny"}})

	if err != nil {
		fmt.Println(err)
	}

	defer resp.Body.Close()

	return resp.StatusCode
}
