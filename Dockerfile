ARG MONGODB_TOOLS_VERSION=100.5.1
ARG EN_AWS_CLI=true
ARG AWS_CLI_VERSION=1.22.46
ARG EN_AZURE=true
ARG AZURE_CLI_VERSION=2.32.0
ARG EN_GCLOUD=true
ARG GOOGLE_CLOUD_SDK_VERSION=370.0.0
ARG EN_GPG=true
ARG GNUPG_VERSION="2.2.31-r0"
ARG EN_MINIO=true
ARG EN_RCLONE=true

FROM golang:1.17 as mgob-builder

ARG VERSION

COPY . /go/src/github.com/stefanprodan/mgob

WORKDIR /go/src/github.com/stefanprodan/mgob

RUN CGO_ENABLED=0 GOOS=linux \
    go build \
    -ldflags "-X main.version=$VERSION" \
    -a -installsuffix cgo \
    -o mgob github.com/stefanprodan/mgob/cmd/mgob

FROM stefanprodan/mgob:1.3 as mgob
WORKDIR /
COPY --from=mgob-builder /go/src/github.com/stefanprodan/mgob/mgob .
VOLUME ["/config", "/storage", "/tmp", "/data"]

ENTRYPOINT [ "./mgob" ]
