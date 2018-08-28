FROM golang:alpine AS build

ENV CGO_ENABLED=0 \
    GOOS=linux

WORKDIR /go/src/github.com/gauravtiwari/mobius

COPY . .

RUN apk add -u git ca-certificates

RUN go get -u github.com/golang/dep/...

ARG github_token

RUN git config --global url."https://${github_token}:@github.com/".insteadOf "https://github.com/"

RUN dep ensure

RUN go build -a -installsuffix cgo -o /go/bin/mobius .

# The compiled output is completely self-contained, with all external libraries
# statically linked into the final binary. This means that we can deploy it
# without any underlying OS, resulting in tiny image sizes.

FROM scratch

WORKDIR /bin

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=build /go/bin/mobius .

EXPOSE 1006

CMD ["mobius"]
