#!/bin/bash

sudo apt-get update
sudo apt-get install -y nginx

sudo tee /etc/nginx/sites-enabled/default > /dev/null <<EOF
server {
    listen 80;
    location / {
        proxy_pass http://s3-ittalent-terraform-gabriel-lins.s3-website-us-east-1.amazonaws.com/;
    }
}
EOF

sudo chown -R www-data:www-data /etc/nginx/sites-enabled/
sudo systemctl restart nginx
