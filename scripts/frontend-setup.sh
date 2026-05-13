#!/bin/bash
set -xe

dnf install nginx -y
systemctl enable --now nginx

rm -rf /usr/share/nginx/html/*

curl -L -o /tmp/frontend.tar.gz \
https://raw.githubusercontent.com/daws-90s/expense-documentation/refs/heads/main/artifacts/expense-frontend-v3.tar.gz

tar -xzf /tmp/frontend.tar.gz -C /usr/share/nginx/html

chown -R nginx:nginx /usr/share/nginx/html

cat > /etc/nginx/conf.d/expense.conf <<EOF
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location /api/ {
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_pass http://${BACKEND_HOST}:8080/;
    }

    location /health {
        stub_status on;
        access_log off;
    }

    location / {
        try_files \$uri /index.html;
    }
}
EOF

nginx -t
systemctl restart nginx