FROM gcr.io/cloud-builders/go:alpine AS build

ENV CGO_ENABLED=0 \
    GOOS=linux

WORKDIR /go/src/mobius

COPY . .



RUN go get -u github.com/golang/dep/...

RUN dep ensure

RUN go build -a -installsuffix cgo -o /go/bin/mobius .

# The compiled outpoutt is completely self-contained, with all external libraries
# statically linked into the final binary. This means that we can deploy it
# without any underlying OS, resulting in tiny image sizes.

FROM scratch

WORKDIR /bin

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=build /go/bin/mobius .

EXPOSE 1006

CMD ["mobius"]
