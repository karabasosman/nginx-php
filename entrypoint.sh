#!/bin/bash
set -e

# Start PHP-FPM
php-fpm -D

# Start Nginx in foreground
# We need to run Nginx with a wrapper script because
# we're running as a non-root user
exec nginx -g "daemon off;"