# Nginx PHP Application

A simple PHP application running with Nginx and PHP-FPM.

## Docker Support

This repository includes Docker support for containerized deployment.

### Prerequisites

- Docker installed on your machine
- Git (optional, for cloning the repository)

### Building the Docker Image

To build the Docker image, run the following command from the root of the repository:

```bash
docker build -t nginx-php-app .
```

### Upgrading Nginx to 1.28.0

The Docker image includes nginx, but it might not be the latest 1.28.0 version. To upgrade to nginx 1.28.0, you can use one of the following methods:

#### Method 1: Using the upgrade script in a custom build

1. Create a custom Dockerfile:
```dockerfile
FROM nginx-php-app
COPY upgrade-nginx.sh /tmp/
RUN /tmp/upgrade-nginx.sh && rm /tmp/upgrade-nginx.sh
```

2. Build the custom image:
```bash
docker build -t nginx-php-app:1.28.0 -f custom.Dockerfile .
```

#### Method 2: Modify the original Dockerfile

1. Modify the Dockerfile:
- Uncomment or add the following lines after the `apt-get update` command:
```dockerfile
&& curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /etc/apt/keyrings/nginx.gpg \
&& apt-get update \
&& apt-get install -y nginx
```

2. Build the image:
```bash
docker build -t nginx-php-app .
```

### Running the Docker Container

To run the container after building the image:

```bash
docker run -p 8080:8080 nginx-php-app
```

This will map port 8080 from the container to port 8080 on your host machine.

### Accessing the Application

Once the container is running, you can access the application by opening a web browser and navigating to:

```
http://localhost:8080
```

You should see the "Hello World" message displayed.

### Environment Variables

No environment variables are required for this application.

### Customization

If you need to customize the Nginx configuration, you can modify the `nginx.conf` file and rebuild the Docker image.