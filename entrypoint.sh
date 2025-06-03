#!/bin/bash
set -e

# Copy Nginx configuration
cp /home/site/wwwroot/nginx-main.conf /etc/nginx/nginx.conf
cp /home/site/wwwroot/nginx.conf /etc/nginx/sites-available/default

# Start PHP-FPM
php-fpm -D

# Start Nginx in foreground
nginx -g "daemon off;"