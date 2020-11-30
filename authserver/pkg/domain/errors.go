package domain

import "errors"

var (
	// ErrRepo unable to handle repository request error
	ErrRepo = errors.New("unable to handle repository request")
)
