# Copyright 2021 The KubeCube Authors. All rights reserved.
# Use of this source code is governed by a Apache license
# that can be found in the LICENSE file.

FROM golang:1.16 as builder

WORKDIR /workspace

COPY . .

# TARGETARCH is set automatically by buildx; a plain native build leaves it
# empty, which makes GOARCH fall back to the build host's architecture.
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=on go build -mod=vendor -a -o audit main.go

FROM alpine:3.13.4
WORKDIR /
COPY --from=builder /workspace/audit .

ENTRYPOINT ["/audit"]