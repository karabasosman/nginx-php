FROM php:8.1-fpm

# Install dependencies and prepare for nginx 1.28.0
# Note: This Dockerfile is set up to make it easy to upgrade to nginx 1.28.0
# (Current version is 1.22.1 from Debian repositories)
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    gnupg2 \
    ca-certificates \
    lsb-release \
    && mkdir -p /etc/apt/keyrings \
    # Create files for nginx repository configuration (will be used by users to upgrade)
    && echo "deb [signed-by=/etc/apt/keyrings/nginx.gpg] http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list \
    && echo "Package: nginx\nPin: version 1.28.0*\nPin-Priority: 1000" > /etc/apt/preferences.d/99-nginx \
    # Output current nginx version for verification
    && echo "Current nginx version: $(nginx -v 2>&1)" \
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