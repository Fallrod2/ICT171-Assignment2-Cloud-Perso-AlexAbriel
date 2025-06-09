# Installation and Deployment

## 1. Prerequisites

- Ubuntu 22.04 (or macOS)
- Docker (>= 20.x) & Docker Compose plugin
- SSH access to the VM (root or sudo)
- A domain name pointing to your VM

## 2. Clone the repository

```bash
git clone https://github.com/YourUsername/ICT171-Assignment2-Cloud-Perso-AlexAbriel.git
cd ICT171-Assignment2-Cloud-Perso-AlexAbriel
```

## 3. Environment configuration

### 3.1 Provided `.env`

We include a ready-to-use `.env` at the repo root. It contains all credentials needed to test the live site:

```env
NEXTCLOUD_ADMIN=admin
NEXTCLOUD_PASS=YourProvidedPassword
DB_USER=oc_user
DB_PASS=oc_pass
DB_NAME=oc_db
```

**Use this file as-is**. If you want custom values, copy it:

```bash
cp .env .env.local
# then edit .env.local
```

## 4. Start the containers

```bash
docker compose pull
docker compose up -d
```

- Verify: `docker ps` should list `db`, `app`, `proxy`, etc.

## 5. Final checks

- NextCloud UI: https://cloud.alex-abriel.com → log in as **admin** with the password from `.env`
