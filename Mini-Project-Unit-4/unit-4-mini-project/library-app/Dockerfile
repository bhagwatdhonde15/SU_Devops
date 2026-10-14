# Multi-stage/Production Dockerfile for Smart Library Management Platform
FROM python:3.10-slim

# Set environment flags
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DATABASE_PATH=/opt/library/data/library.db \
    PORT=5000

# Install system dependencies (curl for healthcheck, sqlite3 for DB diagnostics)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency specifications
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY app.py .

# Create persistent database mount point
RUN mkdir -p /opt/library/data

EXPOSE 5000

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/api/health || exit 1

CMD ["python", "app.py"]
