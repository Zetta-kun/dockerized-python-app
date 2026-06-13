# ============================================
# STAGE 1: BUILDER
# ============================================
FROM python:3.11 AS builder

WORKDIR /app

COPY requirements.txt .

# Dependencies-i qur (normal install, --user yox!)
RUN pip install --no-cache-dir -r requirements.txt

# ============================================
# STAGE 2: PRODUCTION
# ============================================
FROM python:3.11-slim AS production

# Non-root istifadəçi yarat
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --gid 1001 appuser

WORKDIR /app

# Builder-dan bütün Python paketlərini kopyala
COPY --from=builder --chown=appuser:appgroup /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder --chown=appuser:appgroup /usr/local/bin /usr/local/bin

# Tətbiq kodunu kopyala
COPY --chown=appuser:appgroup app.py .

# Non-root istifadəçiyə keç
USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]