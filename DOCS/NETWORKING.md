# Networking, DNS & SSL/TLS

## 1. DNS Configuration

1. In your DNS provider dashboard, create an **A record**:
   - **Name**: `cloud`
   - **Type**: A
   - **Target**: `<YOUR_DROPLET_IP>`
2. Verify propagation:
   ```bash
   dig +short cloud.alex-abriel.com
   # or
   nslookup cloud.alex-abriel.com
   ```

## 2. Nginx Reverse-Proxy (Docker)

- **nginx.conf** at repo root:

  ```nginx
  events {}
  http {
    server {
      listen 80;
      server_name cloud.alex-abriel.com;
      location /.well-known/acme-challenge/ {
        root /usr/share/nginx/html;
      }
      location / {
        return 301 https://$host$request_uri;
      }
    }
    server {
      listen 443 ssl;
      server_name cloud.alex-abriel.com;
      ssl_certificate /etc/letsencrypt/live/cloud.alex-abriel.com/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/cloud.alex-abriel.com/privkey.pem;
      location / {
        proxy_pass http://app:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
      }
    }
  }
  ```

- In your `docker-compose.yml` add:

  ```yaml
  services:
    proxy:
      image: nginx:alpine
      volumes:
        - ./nginx.conf:/etc/nginx/nginx.conf:ro
        - certs:/etc/letsencrypt
        - proxy_data:/usr/share/nginx/html
      ports:
        - "80:80"
        - "443:443"

  volumes:
    certs:
    proxy_data:
  ```

## 3. Obtain & Renew Certificates

1. **Run Certbot**:
   ```bash
   docker run --rm \
     -v "$(pwd)/certs:/etc/letsencrypt" \
     certbot/certbot certonly \
       --webroot -w proxy_data \
       -d cloud.alex-abriel.com \
       --email you@example.com --agree-tos
   ```
2. **Schedule renewal** (on the VM’s crontab):
   ```cron
   0 3 * * * docker run --rm \
     -v /root/ICT171-Assignment2-Cloud-Perso-AlexAbriel/certs:/etc/letsencrypt \
     certbot/certbot renew --quiet
   ```
