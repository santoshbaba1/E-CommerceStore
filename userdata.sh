#!/bin/bash

apt update -y

apt install docker.io -y

systemctl start docker

systemctl enable docker

docker pull santoshbaba1/frontend-v1:latest
docker pull santoshbaba1/user-service-v1:latest
docker pull santoshbaba1/product-service-v1:latest
docker pull santoshbaba1/order-service-v1:latest
docker pull santoshbaba1/cart-service-v1:latest

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
