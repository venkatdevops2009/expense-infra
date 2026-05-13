#!/bin/bash
set -xe

dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs mysql -y

id expense &>/dev/null || useradd --system --home /app --shell /sbin/nologin expense

mkdir -p /app

curl -L -o /tmp/backend.tar.gz \
https://raw.githubusercontent.com/daws-90s/expense-documentation/refs/heads/main/artifacts/expense-backend-v3.tar.gz

tar -xzf /tmp/backend.tar.gz -C /app

cd /app
npm install --omit=dev

chown -R expense:expense /app

# wait for DB
until mysql -h ${DB_HOST} -u expense -pExpenseApp@1 -e "show databases;" >/dev/null 2>&1
do
  echo "waiting for database..."
  sleep 5
done

# import schema (do not fail bootstrap)
if [ -f /app/schema/backend.sql ]; then
  mysql -h ${DB_HOST} -u expense -pExpenseApp@1 transactions < /app/schema/backend.sql || true
fi

# service file
cat > /etc/systemd/system/backend.service <<EOF
[Unit]
Description=Expense Backend
After=network.target

[Service]
User=expense
WorkingDirectory=/app

Environment=PORT=8080
Environment=DB_HOST=${DB_HOST}
Environment=DB_USER=expense
Environment=DB_PWD=ExpenseApp@1
Environment=DB_DATABASE=transactions

ExecStart=/usr/bin/node /app/index.js

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now backend

sleep 10
systemctl status backend --no-pager || true