# Use official lightweight Python image
FROM python:3.13-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

# Set workdir
WORKDIR /app

# Install system dependencies (important for ML + Qdrant client)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libpq-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY requirements.txt .

# Install dependencies
RUN python -m venv .venv && .venv/bin/pip install --upgrade pip && \
    .venv/bin/pip install -r requirements.txt

# Copy app code
COPY . .

# Expose app port (Railway will map automatically)
EXPOSE 8000

# Start with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
