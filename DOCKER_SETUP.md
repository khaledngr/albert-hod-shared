# Docker Setup Guide

This guide will help you set up and run the notebooks using Docker, ensuring a consistent environment across Windows, Mac, and Linux.

## What is Docker and Why Use It?

**Docker** is a tool that packages an application (in this case, Python with all its libraries) into a "container" 

Think of it as a pre-configured, isolated environment that runs the same way on any computer

Instead of struggling to install the correct Python version and dozens of packages manually (which often leads to conflicts, missing dependencies, or version mismatches), Docker gives you a ready-to-use environment with everything already set up

Whether you're on a Windows PC, Mac, or Linux machine, Docker ensures everyone gets **exactly the same** Python version (3.12), the same packages, and the same configuration

Once you have Docker installed, you can start coding without worrying about packages and other issues

## Prerequisites

1. **Install Docker Desktop**:
   - **Windows**: Download from [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
     - Docker Desktop will automatically install WSL2 (Windows Subsystem for Linux 2) if needed
     - Requires Windows 10 64-bit or Windows 11
   - **Mac**: Download from [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
   - **Linux**: Follow instructions for your distribution: [Docker Engine](https://docs.docker.com/engine/install/)

2. **Verify Installation**:
   ```bash
   docker --version
   docker compose version
   ```
   **Note**: Newer Docker Desktop versions use `docker compose` (with a space) instead of `docker-compose` (with a hyphen).

## Quick Start

### Option 1: Using Docker Compose with JupyterLab (Recommended for Jupyter users)

1. Open a terminal in the project directory (`where you have all the files of the course`)

2. Build and start the container:
   ```bash
   docker compose up --build
   ```

3. Open your browser and go to:
   ```
   http://localhost:8888
   ```

4. You should see JupyterLab running with all notebooks accessible!

5. To stop the container, press `Ctrl+C` in the terminal, then run:
   ```bash
   docker compose down
   ```

### Option 1b: Using Dev Containers (Recommended for VS Code/Cursor users)

If you prefer to edit `.ipynb` notebooks directly in VS Code or Cursor (instead of using JupyterLab in the browser):

1. **Install the Dev Containers extension**:
   - VS Code: Install "Dev Containers" extension (by Microsoft)
   - Cursor: Should already have Dev Containers support built-in

2. **Open the project** in VS Code/Cursor

3. **Reopen in Container**: 
   - Press `F1` (or `Cmd+Shift+P` on Mac / `Ctrl+Shift+P` on Windows)
   - Type: "Dev Containers: Reopen in Container"
   - Select it and wait for the container to build (first time takes a few minutes)

4. **That's it!** You can now:
   - Open any `.ipynb` notebook file
   - Run cells directly in VS Code/Cursor
   - Use the integrated Python interpreter
   - Access all your data files normally

5. **Optional**: If you still want JupyterLab, open a terminal in VS Code/Cursor and run:
   ```bash
   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
   ```
   Then open `http://localhost:8888` in your browser.

### Option 2: Using Docker Commands Directly 
(do not do that if you've never used docker before)

1. Build the Docker image:
   ```bash
   docker build -t albert-hod-jupyter .
   ```

2. Run the container:
   ```bash
   docker run -p 8888:8888 \
     -v $(pwd)/notebooks:/workspace/notebooks \
     -v $(pwd)/data:/workspace/data \
     -v $(pwd)/sql:/workspace/sql \
     -v $(pwd):/workspace \
     albert-hod-jupyter
   ```

   **Note for Windows (PowerShell)**: Replace `$(pwd)` with `${PWD}` or use full paths like `C:\path\to\albert-hod-shared`

   **Note for Windows (CMD)**: Replace `$(pwd)` with `%CD%`

3. Open your browser and go to: `http://localhost:8888`

## What's Included

The Docker container includes:
- **Python 3.12** (stable version with good package compatibility)
- All required packages from `requirements.txt`
- **JupyterLab** pre-configured and ready to use
- **NLTK data** pre-downloaded

## Troubleshooting

### Port 8888 already in use
If port 8888 is already in use, you can change it in `docker-compose.yml`:
```yaml
ports:
  - "8889:8888"  # Change 8889 to any available port
```
Then access JupyterLab at `http://localhost:8889`

### Container won't start
1. Make sure Docker Desktop is running
2. Check if ports are available
3. Try rebuilding: `docker compose build --no-cache`

### Changes to notebooks not showing
The notebooks directory is mounted as a volume, so changes should persist. If not:
1. Make sure you're editing files in the `./notebooks` directory on your host machine
2. Refresh the JupyterLab browser tab

### Selenium/Chrome issues
The container doesn't include Chrome and ChromeDriver for simplicity. If you really want to use those try and install it on your own

## Additional Commands

### Run commands inside the container
```bash
docker compose exec jupyter bash
```

### View logs
```bash
docker compose logs -f jupyter
```

### Rebuild after changing requirements.txt
```bash
docker compose build --no-cache
docker compose up
```

## Notes

- All your work is saved automatically as the directories are mounted as volumes (don't forget to save the notebooks!)
- The container runs without password/token for simplicity (localhost only)
- Python version: We use 3.12 for better stability. If you specifically need another version of Python, modify the Dockerfile base image accordingly (but not advised ;) )

