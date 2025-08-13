# Use official lightweight Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Prevent Python from writing pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install OS dependencies (security patches only)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency file first for better caching
COPY requirements.txt .

# Upgrade pip & install dependencies securely (latest versions)
RUN pip install --upgrade pip setuptools wheel && \
    pip install --upgrade --requirement requirements.txt

# Copy application code
COPY . .

# Create a non-root user for security
RUN useradd --create-home appuser
USER appuser

# Expose application port
EXPOSE 8000

# Run the application
CMD ["python", "app.py"]
