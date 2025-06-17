# FROM python:3.11-slim

# WORKDIR /app

# COPY . /app

# # Install dependencies
# RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# # Set environment variable for secret (to be provided at runtime)
# ENV AIPIPE_TOKEN=""

# # Persist chroma_db directory
# VOLUME ["/app/chroma_db"]

# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

FROM python:3.11-slim

WORKDIR /app

# Install build dependencies, then remove them after pip install
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy only requirements first for better caching
COPY requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy only the necessary app files (not .git, not __pycache__, etc.)
COPY . /app

# Remove build dependencies and clean up
RUN apt-get purge -y --auto-remove gcc

ENV AIPIPE_TOKEN=""

VOLUME ["/app/chroma_db"]

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]