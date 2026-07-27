FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
