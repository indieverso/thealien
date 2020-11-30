package logger

import (
	"os"

	"github.com/go-kit/kit/log"
)

// NewLogger creates a new loggger
func NewLogger() log.Logger {
	var logger log.Logger
	{
		logger = log.NewLogfmtLogger(os.Stderr)
		logger = log.NewSyncLogger(logger)
		logger = log.With(logger,
			"service", "thealien-authserver",
			"time:", log.DefaultTimestampUTC,
			"caller", log.DefaultCaller,
		)
	}

	return logger
}
