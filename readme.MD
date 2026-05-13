# Expense Tracker Infrastructure on AWS using Terraform

A 3-tier Expense Tracker deployment on :contentReference[oaicite:0]{index=0} using :contentReference[oaicite:1]{index=1}.

## Architecture

![Architecture Diagram](docs/architecture.png)

## Overview

This project provisions:

- Frontend server using :contentReference[oaicite:2]{index=2}
- Backend server using :contentReference[oaicite:3]{index=3}
- Database server using :contentReference[oaicite:4]{index=4}
- DNS records using :contentReference[oaicite:5]{index=5}

## Project Structure

```text
expense-infra/
├── README.md
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── docs/
│   └── architecture.png
└── scripts/
    ├── database-setup.sh
    ├── backend-setup.sh
    └── frontend-setup.sh
```

## Application Flow

1. User opens `piridishop.shop`
2. Frontend serves static app
3. API calls go to backend `/api/`
4. Backend talks to database
5. Data persists in MySQL

## Infrastructure

### Frontend
- EC2 instance
- Public access
- Port 80
- Reverse proxy to backend

### Backend
- EC2 instance
- Private communication
- Port 8080
- systemd service

### Database
- EC2 instance
- MySQL
- Port 3306

## Security Groups

### frontend-sg
- 80 from internet
- 22 from internet

### backend-sg
- 8080 from frontend-sg
- 22 from internet

### database-sg
- 3306 from backend-sg
- 22 from internet

## DNS

- `piridishop.shop`
- `backend.piridishop.shop`
- `database.piridishop.shop`

## Deployment

### Initialize

```bash
terraform init
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

### Destroy

```bash
terraform destroy
```

## Variables

`terraform.tfvars`

```hcl
ami      = "ami-xxxxxxxx"
key_name = "your-key"
```

## Verification

### Frontend

Open:

https://piridishop.shop

### Backend

```bash
sudo systemctl status backend
curl http://localhost:8080/health
```

### Database

```bash
mysql -u root -pExpenseApp@1 -e "show databases;"
```

## Troubleshooting

### Backend not running

```bash
sudo journalctl -u backend -f
```

### Port check

```bash
ss -lntp | grep 8080
ss -lntp | grep 3306
```

## Future Improvements

- ALB
- Auto Scaling
- RDS
- CI/CD
- SSL
- Monitoring