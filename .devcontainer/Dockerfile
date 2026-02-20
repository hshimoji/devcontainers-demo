FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install just
RUN curl -fsSL https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Install Google Cloud CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg curl && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*
