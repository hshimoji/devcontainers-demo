package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"gopkg.in/yaml.v3"
)

type Config struct {
	DB DBConfig `yaml:"db"`
}

type DBConfig struct {
	Host    string `yaml:"host"`
	Port    int    `yaml:"port"`
	DBName  string `yaml:"dbname"`
	User    string `yaml:"user,omitempty"`
	Password string `yaml:"password,omitempty"`
	SSLMode string `yaml:"sslmode,omitempty"`
}

func main() {
	env := os.Getenv("APPENV")
	if env == "" {
		env = "local"
	}

	cfg, err := loadConfig(fmt.Sprintf("config/%s.yaml", env))
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	dsn := buildDSN(cfg.DB)
	conn, err := pgx.Connect(context.Background(), dsn)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer conn.Close(context.Background())

	var version string
	if err := conn.QueryRow(context.Background(), "SELECT version()").Scan(&version); err != nil {
		log.Fatalf("Query failed: %v", err)
	}

	fmt.Printf("[APPENV=%s] %s\n", env, version)
}

func loadConfig(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var cfg Config
	if err := yaml.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}
	return &cfg, nil
}

func buildDSN(db DBConfig) string {
	dsn := fmt.Sprintf("host=%s port=%d dbname=%s", db.Host, db.Port, db.DBName)
	if db.User != "" {
		dsn += fmt.Sprintf(" user=%s", db.User)
	}
	if db.Password != "" {
		dsn += fmt.Sprintf(" password=%s", db.Password)
	}
	sslmode := db.SSLMode
	if sslmode == "" {
		sslmode = "disable"
	}
	dsn += fmt.Sprintf(" sslmode=%s", sslmode)
	return dsn
}
