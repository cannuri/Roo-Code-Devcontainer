# Use the official TypeScript-Node devcontainer base image
FROM mcr.microsoft.com/devcontainers/typescript-node:1-20-bullseye

# Fix GPG signature verification issues
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --allow-releaseinfo-change && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables to skip GPG checks temporarily during build
# This is a workaround for the signature issues in the build environment
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# Install additional tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git \
    curl \
    wget \
    build-essential \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install global npm packages
RUN npm install -g pnpm@latest

# Switch to node user
USER node

# Set working directory
WORKDIR /workspace

# Keep container running
CMD ["sleep", "infinity"]