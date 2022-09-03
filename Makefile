postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root zen_bank

dropdb:
	docker exec -it postgres12 dropdb zen_bank

migrateup:
	migrate --path db/migration -database "postgresql://root:secret@localhost:5432/zen_bank?sslmode=disable" -verbose up

migratedown:
	migrate --path db/migration -database "postgresql://root:secret@localhost:5432/zen_bank?sslmode=disable" -verbose down

sqlc:
	docker run --rm -v "%cd%:/src" -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

mock:
	mockgen -package mockdb -destination db/mock/store.go zenbank/db/sqlc Store

server:
	go run main.go

.PHONY: server postgres createdb dropdb migrateup migratedown sqlc test mock