FROM golang:1.15-alpine3.12 AS builder

# CGO is required.
RUN apk add build-base

WORKDIR /bin/

COPY main.go go.mod ./

RUN go mod download
#RUN go get -d -v

# -tags musl is required.
RUN CGO_ENABLED=1 GOOS=linux go build -tags musl -a -installsuffix cgo -o app .

FROM alpine:3.12
RUN apk --no-cache add ca-certificates

WORKDIR /bin/

COPY --from=builder /bin/app .

CMD ["./app"]
