package gorm

import (
	"github.com/google/uuid"
	"github.com/indieverso/thealien/authserver/pkg/domain"
)

func toDBModel(entity *domain.Account) *Account {
	id, _ := uuid.Parse(entity.ID)
	account := &Account{
		ID:        id,
		Username:  entity.Username,
		Password:  entity.Password,
		CreatedAt: entity.CreatedAt,
		UpdatedAt: entity.UpdatedAt,
	}

	if entity.DeletedAt != nil {
		account.DeletedAt = entity.DeletedAt
	}

	return account
}

func toDomainModel(entity *Account) *domain.Account {
	return &domain.Account{
		ID:        entity.ID.String(),
		Username:  entity.Username,
		Password:  entity.Password,
		CreatedAt: entity.CreatedAt,
		UpdatedAt: entity.UpdatedAt,
		DeletedAt: entity.DeletedAt,
	}
}
