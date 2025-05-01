FROM itzg/minecraft-server:2025.4.2

# Install Python
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3=3.9.13 python3-pip=23.0.1 curl=7.87.0 && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages openai==1.76.2 boto3==1.38.6

# Set back to container user
USER 1000
