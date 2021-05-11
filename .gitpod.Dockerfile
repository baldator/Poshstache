FROM gitpod/workspace-full:latest
FROM mcr.microsoft.com/powershell:latest

USER root
# Install custom tools, runtime, etc.
RUN apt-get update && apt-get install -y \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN chsh -s /usr/bin/pwsh


# Give back control
USER root
