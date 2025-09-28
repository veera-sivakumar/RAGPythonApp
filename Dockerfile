FROM python:3.13-slim

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libpq-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

# Copy only requirements for caching
COPY requirements.txt .

# Install Python dependencies globally (avoid .venv)
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose port (Railway will override with $PORT)
EXPOSE 8000

# Start uvicorn using the shell form to interpolate $PORT
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
