#!/bin/bash
set -xe

dnf install mysql-server -y
systemctl enable --now mysqld

# wait for mysql startup
until mysqladmin ping --silent; do
  echo "waiting for mysql..."
  sleep 5
done

# set root password (first boot)
mysqladmin -u root password 'ExpenseApp@1' || true

# create database and user
mysql -u root -pExpenseApp@1 <<EOF
CREATE DATABASE IF NOT EXISTS transactions;
CREATE USER IF NOT EXISTS 'expense'@'%' IDENTIFIED BY 'ExpenseApp@1';
GRANT ALL PRIVILEGES ON transactions.* TO 'expense'@'%';
GRANT CREATE USER ON *.* TO 'expense'@'%';
FLUSH PRIVILEGES;
EOF

# allow remote access
grep -q "^bind-address=0.0.0.0" /etc/my.cnf || echo "bind-address=0.0.0.0" >> /etc/my.cnf

systemctl restart mysqld