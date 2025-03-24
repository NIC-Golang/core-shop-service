package tests

import (
	"context"
	"database/sql"
	"log"
	"testing"

	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func setupTestDB() (*sql.DB, error) {
	dsn := "host=postgres port=5432 user=testuser password=testpass dbname=testdb sslmode=disable"
	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, err
	}

	query := `
	CREATE TABLE IF NOT EXISTS users (
	    id SERIAL PRIMARY KEY,
	    name VARCHAR(255) NOT NULL,
	    email VARCHAR(255) UNIQUE NOT NULL,
	    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);`
	_, err = db.Exec(query)
	if err != nil {
		log.Fatalf("error creating the table: %v", err)
	} else {
		log.Println("Table user created or exists")
	}

	return db, nil
}

func TestInsertUser(t *testing.T) {
	db, err := setupTestDB()
	require.NoError(t, err)
	require.NotNil(t, db)
	defer db.Close()

	ctx := context.Background()
	_, err = db.ExecContext(ctx, "INSERT INTO users (name, email) VALUES ($1, $2)", "User", "testUser@example.com")
	assert.NoError(t, err)

	var name string
	err = db.QueryRowContext(ctx, "SELECT name FROM users WHERE email=$1", "testUser@example.com").Scan(&name)
	assert.NoError(t, err)
	assert.Equal(t, "User", name)
}
