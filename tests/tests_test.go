package tests

import (
	"context"
	"database/sql"
	"fmt"
	"os"
	"testing"
	"time"

	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func setupTestDB() (*sql.DB, error) {
	dsn := fmt.Sprintf("host=postsql port=%s user=fiveret password=%s dbname=testdb sslmode=disable", os.Getenv("PORT_SQL"), os.Getenv("POSTGRES_PASS"))
	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, err
	}
	return db, nil
}

func TestInsertUser(t *testing.T) {
	db, err := setupTestDB()
	require.NoError(t, err)
	require.NotNil(t, db)
	defer db.Close()
	email := fmt.Sprintf("user%d@example.com", time.Now().UnixNano())
	ctx := context.Background()
	_, err = db.ExecContext(ctx, "INSERT INTO users (name, email) VALUES ($1, $2)", "User", email)
	assert.NoError(t, err)

	var name string
	err = db.QueryRowContext(ctx, "SELECT name FROM users WHERE email=$1", email).Scan(&name)
	assert.NoError(t, err)
	assert.Equal(t, "User", name)
}
