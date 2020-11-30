package domain

import (
	"time"
)

// Account struct
type Account struct {
	ID         string
	Username   string
	Password   string
	CreatedAt  time.Time
	UpdatedAt  time.Time
	DeletedAt  *time.Time
	ActivateAt *time.Time
}
