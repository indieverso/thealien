package http

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/indieverso/thealien/authserver/pkg/endpoint"
	"github.com/indieverso/thealien/authserver/pkg/middleware"

	httptransport "github.com/go-kit/kit/transport/http"

	"github.com/gorilla/mux"
)

// NewHTTPServer creates a new HTTP Server
func NewHTTPServer(ctx context.Context, endpoints endpoint.Endpoints) http.Handler {
	r := mux.NewRouter()
	r.Use(middleware.JSONEncodeMiddleware)

	r.Methods("POST").Path("/register").Handler(httptransport.NewServer(
		endpoints.Register,
		decodeRegisterRequest,
		encodeResponse,
	))

	r.Methods("POST").Path("/login").Handler(httptransport.NewServer(
		endpoints.Login,
		decodeLoginRequest,
		encodeResponse,
	))

	r.Methods("POST").Path("/refresh").Handler(httptransport.NewServer(
		endpoints.RefreshToken,
		decodeRefreshTokenRequest,
		encodeResponse,
	))

	r.Methods("POST").Path("/validate").Handler(httptransport.NewServer(
		endpoints.RefreshToken,
		decodeValidateTokenRequest,
		encodeResponse,
	))

	return r
}

func encodeResponse(_ context.Context, w http.ResponseWriter, response interface{}) error {
	return json.NewEncoder(w).Encode(response)
}

func decodeRegisterRequest(_ context.Context, r *http.Request) (interface{}, error) {
	var req endpoint.RegisterRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		return nil, err
	}
	return req, nil
}

func decodeLoginRequest(_ context.Context, r *http.Request) (interface{}, error) {
	var req endpoint.LoginRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		return nil, err
	}
	return req, nil
}

func decodeRefreshTokenRequest(_ context.Context, r *http.Request) (interface{}, error) {
	var req endpoint.RefreshTokenRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		return nil, err
	}
	return req, nil
}

func decodeValidateTokenRequest(_ context.Context, r *http.Request) (interface{}, error) {
	var req endpoint.ValidateTokenRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		return nil, err
	}
	return req, nil
}
