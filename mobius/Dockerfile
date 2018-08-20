FROM golang:alpine AS build

ENV CGO_ENABLED=0 \
    GOOS=linux

WORKDIR /go/src/mobius

COPY . .

RUN apk add -u git ca-certificates

RUN go get -u github.com/golang/dep/...

RUN dep ensure

RUN go build -a -installsuffix cgo -o /go/bin/mobius .

FROM scratch

WORKDIR /bin

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=build /go/bin/mobius .

EXPOSE 1006

CMD ["mobius"]
