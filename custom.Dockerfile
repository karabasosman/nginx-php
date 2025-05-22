FROM nginx-php-app

# Upgrade nginx to 1.28.0
COPY upgrade-nginx.sh /tmp/
RUN /tmp/upgrade-nginx.sh && rm /tmp/upgrade-nginx.sh