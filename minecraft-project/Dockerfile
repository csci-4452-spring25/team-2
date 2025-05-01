FROM itzg/minecraft-server:2025.4.2

# Install Python
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3=3.12.2-1~deb12u1 python3-pip=24.0-1~deb12u1 curl=8.6.0-1~deb12u1 && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages openai==1.76.2 boto3==1.38.6

# Set back to container user
USER 1000
