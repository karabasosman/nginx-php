#!/bin/bash
set -e

# Copy Nginx configuration
cp /home/site/wwwroot/nginx.conf /etc/nginx/sites-available/default

# Start PHP-FPM
php-fpm -D

# Start Nginx in foreground
nginx -g "daemon off;"