#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

# Génère le certificat auto-signé avec le VRAI nom de domaine défini dans
# .env (corrige l'incohérence umy.42.fr / ochachi.42.fr de la version
# précédente : le certificat est maintenant toujours cohérent avec
# DOMAIN_NAME, quel que soit le login utilisé).
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/OU=42/CN=${DOMAIN_NAME}"
fi

# Injecte DOMAIN_NAME dans le template pour générer la config finale
envsubst '${DOMAIN_NAME}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Lancer NGINX au premier plan (devient le PID 1 du conteneur)
exec nginx -g "daemon off;"
