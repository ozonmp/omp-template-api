# syntax = docker/dockerfile:1.3
# Builder

ARG GITHUB_PATH=github.com/ozonmp/omp-template-api

FROM golang:1.16-alpine AS builder

WORKDIR /home/${GITHUB_PATH}

RUN apk add --update make git protoc protobuf protobuf-dev curl
COPY Makefile Makefile
RUN make docker-install-deps-go

COPY go.* .
COPY pkg/omp-template-api/go.* ./pkg/omp-template-api/
RUN make docker-download-deps-go

COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build \
    make docker-build-go

# gRPC Server

FROM alpine:latest as server
LABEL org.opencontainers.image.source https://${GITHUB_PATH}
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /home/${GITHUB_PATH}/bin/grpc-server .
COPY --from=builder /home/${GITHUB_PATH}/config.yml .
COPY --from=builder /home/${GITHUB_PATH}/migrations/ ./migrations

RUN chown root:root grpc-server

EXPOSE 50051
EXPOSE 8080
EXPOSE 9100

CMD ["./grpc-server"]
