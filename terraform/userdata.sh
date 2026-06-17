#!/bin/bash

apt update -y

# Install Docker
apt install docker.io -y

systemctl start docker

systemctl enable docker

# Install Nginx
apt install -y nginx certbot python3-certbot-nginx

systemctl start nginx

systemctl enable nginx

# Pull Docker Images

docker pull santoshbaba1/frontend-v1:latest
docker pull santoshbaba1/user-service-v1:latest
docker pull santoshbaba1/product-service-v1:latest
docker pull santoshbaba1/order-service-v1:latest
docker pull santoshbaba1/cart-service-v1:latest

# Run COntainers

docker run -d --name frontend -p 3000:3000 \
santoshbaba1/frontend-v1:latest

docker run -d --name user -p 3001:3001 \
santoshbaba1/user-service-v1:latest

docker run -d --name product -p 3002:3002 \
santoshbaba1/product-service-v1:latest

docker run -d --name order -p 3003:3003 \
santoshbaba1/order-service-v1:latest

docker run -d --name cart -p 3004:3004 \
santoshbaba1/cart-service-v1:latest

# Create Custom Nginx Configuration

cat > /etc/nginx/sites-available/ecommerce << 'EOF'
server {

    listen 80;
    server_name graphtech.live www.graphtech.live;

    location / {
        proxy_pass http://localhost:3000;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /api/users/ {
        proxy_pass http://localhost:3001/;
    }

    location /api/products/ {
        proxy_pass http://localhost:3002/;
    }

    location /api/orders/ {
        proxy_pass http://localhost:3003/;
    }

    location /api/cart/ {
        proxy_pass http://localhost:3004/;
    }
}
EOF

# Enable Site
rm -f /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/ecommerce \
/etc/nginx/sites-enabled/ecommerce

# Test Nginx
nginx -t

# Restart Nginx
systemctl restart nginx
