FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Create directory structure
RUN mkdir -p /home/site/wwwroot

# Copy application files
COPY index.php /home/site/wwwroot/
COPY nginx.conf /home/site/wwwroot/
COPY startup.sh /home/site/wwwroot/
COPY entrypoint.sh /entrypoint.sh

# Make scripts executable
RUN chmod +x /home/site/wwwroot/startup.sh \
    && chmod +x /entrypoint.sh

# Expose the port specified in nginx.conf
EXPOSE 8080

# Set working directory
WORKDIR /home/site/wwwroot

# Start PHP-FPM and Nginx
ENTRYPOINT ["/entrypoint.sh"]