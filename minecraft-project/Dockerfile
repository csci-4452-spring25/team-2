FROM itzg/minecraft-server:latest

# Install Python
USER root
RUN apt-get update && apt-get install -y python3 python3-pip curl

RUN pip3 install --break-system-packages openai boto3

# Set back to container user
USER 1000
