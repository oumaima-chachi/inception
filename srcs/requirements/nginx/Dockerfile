FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf.template /etc/nginx/conf.d/default.conf.template

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 443

CMD ["/setup.sh"]
