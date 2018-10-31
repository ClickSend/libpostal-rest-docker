package main

import (
	"fmt"
	"net/http"
	"net/url"
)

// Parser returns parsed postal address submitted.
func Parser() int {
	// Test query body
	resp, err := http.PostForm("http://localhost:8080/parser", url.Values{"query": {"100 main st buffalo ny"}})

	if err != nil {
		fmt.Println(err)
	}

	defer resp.Body.Close()

	return resp.StatusCode
}