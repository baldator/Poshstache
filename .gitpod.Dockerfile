FROM gitpod/workspace-full:latest

USER root
# Install custom tools, runtime, etc.
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update && apt-get install -y \
    && add-apt-repository universe \
    && apt-get install -y powershell \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

USER gitpod
# Apply user-specific settings

# Give back control
USER root