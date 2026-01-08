# Dev Container Dockerfile - extends the main Dockerfile but doesn't auto-start JupyterLab
FROM python:3.12-slim

# Set working directory
WORKDIR /workspace

# Install minimal system dependencies (needed for compiling some Python packages)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir numpy==1.26.4 && \
    pip install --no-cache-dir -r requirements.txt

# Download NLTK data
RUN python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords'); nltk.download('vader_lexicon')" || true

# Expose Jupyter port (if students want to use JupyterLab manually)
EXPOSE 8888

# Keep container running - VS Code/Cursor will connect to this
# Students can run 'jupyter lab' manually if they want the web interface
CMD ["sleep", "infinity"]

