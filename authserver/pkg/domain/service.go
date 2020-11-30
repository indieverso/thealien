package domain

import (
	"context"

	"github.com/pkg/errors"

	"github.com/dgrijalva/jwt-go"
	"github.com/go-kit/kit/log"
	"golang.org/x/crypto/bcrypt"
)

// Service interface
type Service interface {
	Register(ctx context.Context, account *Account) (*Account, error)
	Login(ctx context.Context, username string, password string) (string, error)
	ValidateToken(ctx context.Context, token string) (bool, error)
	RefreshToken(ctx context.Context, token string) (string, error)
}

// AccountService struct
type AccountService struct {
	repo   Repository
	logger log.Logger
}

// NewService creates a new account service
func NewService(r Repository, l log.Logger) *AccountService {
	return &AccountService{repo: r, logger: l}
}

// Register new account
func (s AccountService) Register(ctx context.Context, account *Account) (*Account, error) {
	account.Password = hashPassword([]byte(account.Password))
	created, err := s.repo.Store(account)
	if err != nil {
		return nil, errors.Wrap(err, "Service.Register")
	}
	return created, nil
}

// Login to account and returns jwt token
func (s AccountService) Login(ctx context.Context, user string, pass string) (string, error) {
	account, err := s.repo.FindOne(map[string]interface{}{"username": user})
	if err != nil {
		return "", errors.Wrap(err, "Service.Login")
	}

	perr := bcrypt.CompareHashAndPassword([]byte(account.Password), []byte(pass))
	if perr != nil {
		return "", errors.Wrap(err, "Service.Login")
	}

	token, err := generateToken()
	if err != nil {
		return "", errors.Wrap(err, "Service.Login")
	}

	return token, nil
}

// ValidateToken validates the token
func (s AccountService) ValidateToken(ctx context.Context, token string) (bool, error) {
	return false, errors.New("Must implement")
}

// RefreshToken refreshes the token
func (s AccountService) RefreshToken(ctx context.Context, token string) (string, error) {
	return "", errors.New("Must implement")
}

func generateToken() (string, error) {
	t := jwt.New(jwt.SigningMethodHS256)
	token, err := t.SignedString([]byte("SECRET_KEY_HERE"))
	if err != nil {
		return "", err
	}
	return token, nil
}

func hashPassword(p []byte) string {
	hash, err := bcrypt.GenerateFromPassword(p, bcrypt.MinCost)
	if err != nil {
		return ""
	}
	return string(hash)
}
