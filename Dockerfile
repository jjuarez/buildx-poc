# syntax=docker/dockerfile:1.4
FROM golang:1.18@sha256:3f0168c019343d7cc07bf2481e7b6555fbf2ebadfb01f9e77875da66439ba041 AS builder

WORKDIR /build
COPY . ./
RUN make build


FROM alpine:3.15.4@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454 AS runtime
COPY --from=builder --link /build/myapp /bin/

ENTRYPOINT [ "/bin/myapp" ]
