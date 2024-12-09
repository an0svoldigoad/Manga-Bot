# Use a specific Python version for reproducibility
FROM python:3.10-slim

# Environment variables to optimize container behavior
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies required for Python packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    python3-dev \
    && apt-get clean

# Copy requirements file first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN python -m pip install --upgrade pip
RUN python -m pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app

# Apply database migrations
RUN alembic upgrade head

# Default command
CMD ["bash", "start.sh"]
