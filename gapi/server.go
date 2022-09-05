package gapi

import (
	"fmt"
	db "zenbank/db/sqlc"
	"zenbank/pb"
	"zenbank/token"
	"zenbank/util"
)

// Server serves HTTP requests for our banking service.
type Server struct {
	pb.ZenbankServer
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
}

// NewServer creates a new gRPC server and set up routing.
func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}
