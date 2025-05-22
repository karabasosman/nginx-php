FROM php:8.1-fpm

# Install dependencies and clean up in the same layer to reduce image size
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directory structure
RUN mkdir -p /home/site/wwwroot && \
    mkdir -p /home/site/logs && \
    touch /home/site/logs/access.log && \
    touch /home/site/logs/error.log

# Create a non-root user to run the application
RUN groupadd -r appgroup && \
    useradd -r -g appgroup -s /sbin/nologin -d /home/site/wwwroot appuser && \
    chown -R appuser:appgroup /home/site

# Configure Nginx to run with proper permissions
RUN mkdir -p /var/lib/nginx/body \
    /var/lib/nginx/fastcgi \
    /var/lib/nginx/proxy \
    /var/lib/nginx/scgi \
    /var/lib/nginx/uwsgi \
    /var/cache/nginx && \
    chown -R appuser:appgroup \
    /var/lib/nginx \
    /var/log/nginx \
    /var/cache/nginx \
    /run

# Copy configuration and application files
COPY --chown=appuser:appgroup nginx.conf /etc/nginx/sites-available/default
COPY --chown=appuser:appgroup index.php /home/site/wwwroot/
COPY --chown=appuser:appgroup nginx.conf /home/site/wwwroot/
COPY --chown=appuser:appgroup entrypoint.sh /entrypoint.sh

# Update nginx.conf to use the logs directory
RUN sed -i 's|/home/site/access.log|/home/site/logs/access.log|g' /etc/nginx/sites-available/default && \
    sed -i 's|/home/site/error.log|/home/site/logs/error.log|g' /etc/nginx/sites-available/default && \
    sed -i 's|/home/site/access.log|/home/site/logs/access.log|g' /home/site/wwwroot/nginx.conf && \
    sed -i 's|/home/site/error.log|/home/site/logs/error.log|g' /home/site/wwwroot/nginx.conf

# Make entrypoint script executable
RUN chmod 755 /entrypoint.sh && \
    # PHP-FPM needs write access to certain directories
    mkdir -p /var/run/php && \
    chown -R appuser:appgroup /var/run/php

# Configure PHP-FPM to run as the appuser
RUN sed -i 's/user = www-data/user = appuser/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/group = www-data/group = appgroup/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/listen.owner = www-data/listen.owner = appuser/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/listen.group = www-data/listen.group = appgroup/g' /usr/local/etc/php-fpm.d/www.conf

# Expose the port specified in nginx.conf
EXPOSE 8080

# Add healthcheck to monitor application status
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Set working directory
WORKDIR /home/site/wwwroot

# Switch to non-root user
USER appuser

# Start PHP-FPM and Nginx
ENTRYPOINT ["/entrypoint.sh"]