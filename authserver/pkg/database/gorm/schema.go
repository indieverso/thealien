package gorm

import (
	"time"

	"github.com/google/uuid"
	"github.com/jinzhu/gorm"
)

// Account struct
type Account struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key;"`
	Username  string    `gorm:"unique;index;"`
	Password  string
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time
}

// BeforeCreate gorm hook
func (a Account) BeforeCreate(scope *gorm.Scope) error {
	id := uuid.New()
	err := scope.SetColumn("ID", id)
	if err != nil {
		return err
	}
	return nil
}
