This setup reduces manual deployment effort and improves deployment consistency through full automation.

# DevOps Infrastructure on GCP (Terraform + Docker + CI/CD + Monitoring)

This project demonstrates a production-like DevOps infrastructure deployed on Google Cloud Platform using Infrastructure as Code, containerized services, CI/CD automation, and full observability stack.

---

## Architecture

Cloudflare → Traefik (Reverse Proxy) → Docker → Applications

- Cloudflare handles DNS, SSL (Full Strict), and security protection  
- Traefik acts as reverse proxy with automatic HTTPS (Let's Encrypt)  
- Docker manages multi-service containerized applications  
- Internal services are isolated using Docker networks  

---

## Key Features

- **Infrastructure as Code (IaC)** using Terraform  
- **Automated VM provisioning** with startup scripts  
- **Containerized deployment** using Docker & Docker Compose  
- **CI/CD pipeline** using GitHub Actions with self-hosted runner  
- **Image-based deployment** (no source code stored on server)  
- **Reverse proxy routing** with Traefik and HTTPS support  
- **Monitoring & Observability stack**:
  - Prometheus (metrics)
  - Grafana (dashboard)
  - Loki + Promtail (logs)
  - cAdvisor & Node Exporter (system/container metrics)
- **Secure access control**:
  - SSH via private network (Tailscale)
  - Firewall rules (only HTTP/HTTPS exposed)
  - Cloudflare protection (bot & DDoS mitigation)

---

## Project Structure
infra-danz-public/
│
├── terraform/ # Infrastructure provisioning (GCP VM)
├── docker/ # Containerized services
│ ├── core/ # Reverse proxy (Traefik)
│ ├── monitoring/ # Prometheus, Grafana, Loki stack
│ ├── apps/ # Application services
│ └── cicd/ # Self-hosted GitHub runner
│
├── scripts/
│ └── deploy.sh # Deployment orchestration script
│
├── .gitignore
└── README.md

---

## Deployment Flow

1. Terraform provisions a VM on Google Cloud Platform  
2. Startup script installs Docker and prepares environment  
3. Infrastructure repository is cloned into the server  
4. `deploy.sh` initializes networks and starts services  
5. Applications become accessible via Traefik and HTTPS  

---

## CI/CD Workflow

- Automated build and push of Docker images  
- Self-hosted runner executes deployment  
- Server pulls latest image (no build in production)  
- Ensures consistent and reproducible deployment
- Uses commit-based image tagging for traceable deployments

---

## Monitoring & Observability

The system includes a full monitoring stack:

- **Prometheus** for metrics collection  
- **Grafana** for visualization dashboards  
- **Loki + Promtail** for centralized logging  
- **Node Exporter & cAdvisor** for system and container metrics  

---

## Security

- Public access limited to **HTTP/HTTPS only**  
- SSH access restricted via **private VPN (Tailscale)**  
- SSL/TLS enforced using **Cloudflare + Let's Encrypt**  
- Basic intrusion protection via firewall and network isolation  

---

## Technologies Used

- Google Cloud Platform (Compute Engine)  
- Terraform (Infrastructure as Code)  
- Docker & Docker Compose  
- Traefik (Reverse Proxy)  
- GitHub Actions (CI/CD)  
- Prometheus, Grafana, Loki  
- Linux (Ubuntu Server)  
- Cloudflare (DNS, SSL, Security)  

---

## Notes

This repository is a **sanitized public version** of a real infrastructure setup.  
Sensitive data such as credentials, tokens, and environment variables have been removed for security purposes.

---

## Author

**Said Abdan Syakur**  
- GitHub: https://github.com/Dans9881
- LinkedIn: https://linkedin.com/in/said-abdan-syakur