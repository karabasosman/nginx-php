FROM php:8.1-fpm

# Install dependencies and setup nginx official repository
RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    curl \
    # Add nginx official signing key from keyserver
    && curl -fsSL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62" | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg \
    # Add nginx official repository
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/debian $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list \
    # Set nginx.org repository priority
    && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx \
    # Update package lists and install nginx (will use official repo if available, otherwise fall back to default)
    && apt-get update \
    && apt-get install -y nginx \
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