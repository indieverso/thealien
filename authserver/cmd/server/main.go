package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/go-kit/kit/log/level"
	"github.com/indieverso/thealien/authserver/pkg/config"
	database "github.com/indieverso/thealien/authserver/pkg/database/gorm"
	"github.com/indieverso/thealien/authserver/pkg/domain"
	"github.com/indieverso/thealien/authserver/pkg/endpoint"
	"github.com/indieverso/thealien/authserver/pkg/logger"
	transport "github.com/indieverso/thealien/authserver/pkg/transport/http"
)

func main() {
	// Logger
	logger := logger.NewLogger()

	// Configuration
	configPath := os.Getenv("AUTHSERVER_CONFIG_PATH")
	if configPath == "" {
		configPath = "./config.yml"
	}

	cfg, err := config.NewConfig(configPath)
	if err != nil {
		level.Error(logger).Log("exit", err)
		os.Exit(-1)
	}

	level.Info(logger).Log("msg", "service started")
	defer level.Info(logger).Log("msg", "service ended")

	// Database
	db, err := database.Connect(cfg.Database)
	if err != nil {
		level.Error(logger).Log("exit", err)
		os.Exit(-1)
	}

	ctx := context.Background()
	rep := database.NewRepository(db, logger)
	svc := domain.NewService(rep, logger)

	errs := make(chan error)

	go func() {
		c := make(chan os.Signal, 1)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
		errs <- fmt.Errorf("%s", <-c)
	}()

	endpoints := endpoint.MakeEndpoints(svc)

	// HTTP Server
	go func() {
		fmt.Println("HTTP Server Listening on", cfg.Server.HTTP.Host)
		server := transport.NewHTTPServer(ctx, endpoints)
		errs <- http.ListenAndServe(cfg.Server.HTTP.Host, server)
	}()

	level.Error(logger).Log("exit", <-errs)
}
