# Build
FROM golang:1.14-alpine AS builder

RUN apk --no-cache add git curl openssh make

WORKDIR $GOPATH/src/github.com/indieverso/authserver
ADD . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -ldflags '-extldflags "-static"' -o bin/authserver cmd/server/main.go

# Main
FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /server

COPY --from=builder /go/src/github.com/indieverso/authserver/bin/authserver .

CMD ["./authserver"]