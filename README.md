# 🐳 Dockerized Python App with Multi-Stage Build

[![Docker Pulls](https://img.shields.io/docker/pulls/zetta255/dockerized-python-app)](https://hub.docker.com/r/zetta255/dockerized-python-app)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104-green)](https://fastapi.tiangolo.com/)

## 📌 About

Production-ready FastAPI application with **multi-stage Docker build** that reduces image size from **1.2GB to 120MB** (90% reduction).

## 🚀 Image Size Comparison

| Stage | Base Image | Size |
|-------|------------|------|
| Without multi-stage | `python:3.11` | ~1.2GB |
| **With multi-stage** | `python:3.11-slim` | **~120MB** |

## 🛠️ Technologies

| Technology | Purpose |
|------------|---------|
| **Docker** | Containerization |
| **Multi-stage Build** | Image optimization |
| **FastAPI** | Python web framework |
| **Uvicorn** | ASGI server |

## 📁 Project Structure
dockerized-python-app/
├── Dockerfile # Multi-stage Dockerfile
├── app.py # FastAPI application
├── requirements.txt # Python dependencies
├── .dockerignore # Files excluded from Docker
├── tests/ # Unit tests
├── README.md
└── LICENSE

📝 Dockerfile Explanation

# Stage 1: Builder (large image with build tools)
FROM python:3.11 AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Production (smallest, secure)
FROM python:3.11-slim AS production
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --gid 1001 appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appgroup /root/.local /home/appuser/.local
COPY app.py .
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH
HEALTHCHECK --interval=30s CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

📄 License

MIT

👤 Author

Zetta-kun - GitHub