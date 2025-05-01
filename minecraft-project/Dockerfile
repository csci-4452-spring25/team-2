FROM itzg/minecraft-server:2025.4.2

# Install Python
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3=3.12.3 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages openai==1.76.2 boto3==1.38.6

# Set back to container user
USER 1000
