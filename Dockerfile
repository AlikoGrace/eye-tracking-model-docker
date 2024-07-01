# FROM debian:bookworm as build

# # Set environment variables to avoid interactive prompts
# ENV DEBIAN_FRONTEND=noninteractive

# # Install build dependencies
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     cmake \
#     libopenblas-dev \
#     liblapack-dev \
#     libx11-dev \
#     libgtk-3-dev \
#     libboost-python-dev \
#     python3-pip \
#     && rm -rf /var/lib/apt/lists/*

# # Set the working directory
# WORKDIR /app

# # Copy requirements.txt and install dependencies
# COPY requirements.txt requirements.txt
# RUN pip3 install --no-cache-dir -r requirements.txt

# # Copy the rest of the application code
# COPY . .

# # Final stage
# FROM debian:bookworm

# # Set environment variables to avoid interactive prompts
# ENV DEBIAN_FRONTEND=noninteractive

# # Install runtime dependencies
# RUN apt-get update && apt-get install -y \
#     libopenblas0-pthread \
#     liblapack3 \
#     libx11-6 \
#     libgtk-3-0 \
#     libboost-python1.74.0 \
#     python3 \
#     python3-pip \
#     && rm -rf /var/lib/apt/lists/*

# # Copy installed dependencies and application code from the build stage
# COPY --from=build /usr/local/lib/python3.11/dist-packages /usr/local/lib/python3.11/dist-packages
# COPY --from=build /app /app

# # Set the working directory
# WORKDIR /app

# # Command to run the application
# CMD ["gunicorn", "app:app"]





# Stage 1: Build stage
FROM debian:bookworm as build

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    libboost-python-dev \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy requirements.txt and install dependencies in a virtual environment
COPY requirements.txt requirements.txt
RUN python3 -m venv venv
RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Stage 2: Runtime stage
FROM debian:bookworm

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libopenblas0-pthread \
    liblapack3 \
    libx11-6 \
    libgtk-3-0 \
    libboost-python1.74.0 \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed dependencies and application code from the build stage
COPY --from=build /app /app

# Set the working directory
WORKDIR /app

# Activate the virtual environment
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Command to run the application
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "--timeout", "120", "app:app"]
