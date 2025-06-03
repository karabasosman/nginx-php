#!/bin/bash

cp /home/site/wwwroot/nginx-main.conf /etc/nginx/nginx.conf
cp /home/site/wwwroot/nginx.conf /etc/nginx/sites-available/default
service nginx reload
