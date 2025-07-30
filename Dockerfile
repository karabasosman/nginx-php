FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for running the application
RUN groupadd -r appgroup && useradd -r -g appgroup -d /home/site -s /bin/bash appuser

# Configure nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Create directory structure and set proper ownership
RUN mkdir -p /home/site/wwwroot

# Copy application files
COPY index.php /home/site/wwwroot/
COPY nginx.conf /home/site/wwwroot/
COPY startup.sh /home/site/wwwroot/
COPY entrypoint.sh /entrypoint.sh

# Make scripts executable and set proper ownership
RUN chmod +x /home/site/wwwroot/startup.sh \
    && chmod +x /entrypoint.sh \
    && chown -R appuser:appgroup /home/site

# Expose the port specified in nginx.conf
EXPOSE 8080

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Set working directory
WORKDIR /home/site/wwwroot

# Start PHP-FPM and Nginx
ENTRYPOINT ["/entrypoint.sh"]