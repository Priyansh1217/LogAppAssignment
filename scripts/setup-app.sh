#!/bin/bash
# setup-app.sh
# -----------------------------------
# Installs Python app and starts logging service

set -e

echo "🔧 Updating system packages..."
sudo yum update -y

echo "📦 Installing dependencies..."
sudo yum install -y python3

echo "📁 Creating app directory..."
sudo mkdir -p /opt/logapp
sudo chmod -R 755 /opt/logapp

echo "📝 Creating sample log generator app..."
sudo tee /opt/logapp/app.py > /dev/null << 'EOF'
import time, logging, random

# Configure the logger
logging.basicConfig(
    filename="/opt/logapp/app.log",
    level=logging.INFO,
    format="%(asctime)s - %(message)s"
)

# Example log event
