FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
