build:
	go build -v ./...

test:
	go test -v ./...

run:
	go run .

gomod2nix-update:
	gomod2nix generate
