package main

import (
	"fmt"
	"net/http"
)

// Health returns health status of service.
func Health() int {
	// Test health endpoint
	resp, err := http.Get("http://localhost:8080/health")

	if err != nil {
		fmt.Println(err)
	}

	defer resp.Body.Close()

	return resp.StatusCode
}