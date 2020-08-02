ARG VERSION=0.12.29

FROM golang:alpine as builder

ARG VERSION

RUN apk add --update binutils upx
ADD https://github.com/hashicorp/terraform/archive/v${VERSION}.zip terraform.zip

RUN unzip terraform.zip && \
  cd terraform-${VERSION} && \
  go install ./tools/terraform-bundle && \
  strip /go/bin/terraform-bundle && \
  upx /go/bin/terraform-bundle

FROM hashicorp/terraform:${VERSION}
LABEL maintainer="Nate Wilken <wilken@asu.edu>"

COPY --from=builder /go/bin/terraform-bundle /bin/terraform-bundle