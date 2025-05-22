#!/bin/bash
set -e

# This script upgrades nginx to version 1.28.0 from the official nginx repository

# Get nginx key and add it to keyring
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /etc/apt/keyrings/nginx.gpg

# Verify that sources list is properly configured
if [ ! -f /etc/apt/sources.list.d/nginx.list ]; then
    echo "deb [signed-by=/etc/apt/keyrings/nginx.gpg] http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list
fi

# Verify that pin preferences are properly configured
if [ ! -f /etc/apt/preferences.d/99-nginx ]; then
    echo "Package: nginx
Pin: version 1.28.0*
Pin-Priority: 1000" > /etc/apt/preferences.d/99-nginx
fi

# Update apt and install nginx 1.28.0
apt-get update
apt-get install -y nginx

# Verify the installed version
nginx -v