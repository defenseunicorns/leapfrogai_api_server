FROM cgr.dev/chainguard/go:1.20 as build

WORKDIR /work

ADD go.mod .
ADD go.sum .
ADD main.go .
ADD backends backends
ADD config config
ADD pkg pkg
ADD models.toml .
RUN go env
RUN GOOS=linux GOARCH=amd64  CGO_ENABLED=0 go build -ldflags '-extldflags "-static"' -o app main.go

FROM cgr.dev/chainguard/static:latest
COPY --from=build /work/app /app
COPY models.toml .

EXPOSE 8080
CMD ["/app"]