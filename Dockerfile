FROM --platform=${BUILDPLATFORM} docker.io/golang:1.23.5 AS builder
ARG TARGETARCH

WORKDIR /go/src/github.com/embik/rpi_exporter
COPY . .
RUN GOOS=linux GOARCH=${TARGETARCH:-arm64} go build -o rpi_exporter ./cmd/rpi_exporter

FROM gcr.io/distroless/static-debian12:debug-arm64
LABEL org.opencontainers.image.source=https://github.com/embik/rpi_exporter
LABEL org.opencontainers.image.description="Prometheus exporter for Raspberry Pi hardware metrics"
LABEL org.opencontainers.image.licenses=MIT

COPY --from=builder /go/src/github.com/embik/rpi_exporter /usr/local/bin/rpi_exporter

USER nobody
EXPOSE 9110
ENTRYPOINT [ "rpi_exporter", "-addr=:9110" ]
