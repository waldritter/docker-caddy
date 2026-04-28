ARG CADDY_VERSION

FROM --platform=${BUILDPLATFORM} caddy:${CADDY_VERSION}-builder-alpine AS builder

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

RUN GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    xcaddy build \
    --with github.com/caddy-dns/hetzner/v2 \
    --with github.com/greenpau/caddy-security@main \
    --with github.com/greenpau/caddy-trace@latest \
    --with github.com/ggicci/caddy-jwt

FROM caddy:${CADDY_VERSION}-alpine

RUN apk add --no-cache tzdata
ENV TZ=Europe/Berlin

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
