ARG CADDY_VERSION

FROM --platform=${BUILDPLATFORM} caddy:${CADDY_VERSION}-builder AS builder

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

RUN GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    xcaddy build \
    --with github.com/caddy-dns/hetzner \
    --with github.com/greenpau/caddy-security@latest \
    --with github.com/greenpau/caddy-trace@latest

FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
