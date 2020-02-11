# Setup build arguments with default versions
ARG GITLAB_RUNNER_VERSION=v12.7.1
ARG AWS_ECR_HELPER_VERSION=v0.4.0
ARG ALPINE_VERSION=3.9

FROM alpine:${ALPINE_VERSION} AS certs
RUN apk --no-cache add "ca-certificates=20190108-r0"

FROM golang:1.12.7-alpine${ALPINE_VERSION} AS build
RUN apk --no-cache add git gcc g++ musl-dev
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/...
WORKDIR /go/src/github.com/awslabs/amazon-ecr-credential-helper
RUN git checkout ${AWS_ECR_HELPER_VERSION}
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
RUN go build -ldflags "-s -w" -installsuffix cgo -a -o /ecr-login \
    ./ecr-login/cli/docker-credential-ecr-login

FROM gitlab/gitlab-runner:alpine-${GITLAB_RUNNER_VERSION}
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /ecr-login /usr/bin/docker-credential-ecr-login
