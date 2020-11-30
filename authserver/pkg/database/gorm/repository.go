package gorm

import (
	"github.com/go-kit/kit/log"
	"github.com/indieverso/thealien/authserver/pkg/domain"
	"github.com/jinzhu/gorm"
	"github.com/pkg/errors"
)

// Repository struct
type Repository struct {
	db     *gorm.DB
	logger log.Logger
}

// NewRepository for gorm
func NewRepository(db *gorm.DB, logger log.Logger) *Repository {
	db.AutoMigrate(&Account{})

	return &Repository{
		db:     db,
		logger: logger,
	}
}

// Store a new account
func (r Repository) Store(account *domain.Account) (*domain.Account, error) {
	entity := toDBModel(account)

	if err := r.db.Create(entity).Error; err != nil {
		return nil, errors.Wrap(err, "Repository.Store")
	}

	return toDomainModel(entity), nil
}

// FindOne filter account by parameter
func (r Repository) FindOne(w map[string]interface{}) (*domain.Account, error) {
	var result Account

	query := r.db.Where(w).First(&result)

	if query.RecordNotFound() {
		return nil, errors.New("Account not found")
	}

	if err := query.Error; err != nil {
		return nil, errors.Wrap(err, "Repository.FindBy")
	}

	return toDomainModel(&result), nil
}
