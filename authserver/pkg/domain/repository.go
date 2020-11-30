package domain

// Repository interface
type Repository interface {
	Store(account *Account) (*Account, error)
	FindOne(o map[string]interface{}) (*Account, error)
}
