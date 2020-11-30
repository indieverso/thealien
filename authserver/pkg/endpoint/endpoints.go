package endpoint

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/go-kit/kit/endpoint"
	"github.com/indieverso/thealien/authserver/pkg/domain"
	"github.com/indieverso/thealien/authserver/pkg/validator"
)

type (
	// RegisterRequest struct
	RegisterRequest struct {
		Username        string `json:"username" validate:"required,min=4"`
		Password        string `json:"password" validate:"required,min=6"`
		ConfirmPassword string `json:"confirm_password" validate:"required,eqfield=Password"`
	}
	// RegisterResponse struct
	RegisterResponse struct {
		ID string `json:"id"`
	}

	// LoginRequest struct
	LoginRequest struct {
		Username string `json:"username" validate:"required,min=4"`
		Password string `json:"password" validate:"required,min=6"`
	}
	// LoginResponse struct
	LoginResponse struct {
		Token string `json:"token"`
	}

	// RefreshTokenRequest struct
	RefreshTokenRequest struct {
		Token string `json:"token"`
	}
	// RefreshTokenResponse struct
	RefreshTokenResponse struct {
		Token string `json:"token"`
	}

	// ValidateTokenRequest struct
	ValidateTokenRequest struct {
		Token string `json:"token"`
	}
	// ValidateTokenResponse struct
	ValidateTokenResponse struct {
		Status bool `json:"status"`
	}
)

// Endpoints struct for this service
type Endpoints struct {
	Register      endpoint.Endpoint
	Login         endpoint.Endpoint
	RefreshToken  endpoint.Endpoint
	ValidateToken endpoint.Endpoint
}

// MakeEndpoints generate the service endpoints
func MakeEndpoints(s domain.Service) Endpoints {
	return Endpoints{
		Register:      makeRegisterEndpoint(s),
		Login:         makeLoginEndpoint(s),
		RefreshToken:  makeRefreshTokenEndpoint(s),
		ValidateToken: makeValidateTokenEndpoint(s),
	}
}

func makeRegisterEndpoint(s domain.Service) endpoint.Endpoint {
	return func(ctx context.Context, r interface{}) (interface{}, error) {
		req := r.(RegisterRequest)

		validator := validator.NewValidator()
		if err := validator.Validate(req); err != nil {
			return nil, err
		}

		data, _ := json.Marshal(req)

		var account domain.Account
		json.Unmarshal([]byte(data), &account)

		created, err := s.Register(ctx, &account)
		if err != nil {
			return nil, err
		}

		return RegisterResponse{ID: created.ID}, err
	}
}

func makeLoginEndpoint(s domain.Service) endpoint.Endpoint {
	return func(ctx context.Context, r interface{}) (interface{}, error) {
		req := r.(LoginRequest)

		validator := validator.NewValidator()
		if err := validator.Validate(req); err != nil {
			return nil, err
		}

		token, err := s.Login(ctx, req.Username, req.Password)
		if err != nil {
			return nil, err
		}

		return LoginResponse{Token: token}, nil
	}
}

func makeRefreshTokenEndpoint(s domain.Service) endpoint.Endpoint {
	return func(ctx context.Context, r interface{}) (interface{}, error) {
		return nil, fmt.Errorf("Need implementation")
	}
}

func makeValidateTokenEndpoint(s domain.Service) endpoint.Endpoint {
	return func(ctx context.Context, r interface{}) (interface{}, error) {
		return nil, fmt.Errorf("Need implementation")
	}
}
