#!/bin/bash

set -e

echo "🚀 Powered by Tenbyte Technologies"
echo "⚠️  Disclaimer: Use this script at your own risk. We assume no responsibility for any issues, errors or data loss."
echo "-----------------------------------------------------------------------"

echo "🛠️  Anytype AnySync Selfhost Auto-Installer for Ubuntu"
echo "------------------------------------------------------"
read -p "📡 Enter your public domain or IP (e.g. domain.example.com): " HOST

ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)

echo "📦 Installing Docker and dependencies..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release git make python3 ufw

echo "🔐 Setting up Docker repository..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🔧 Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "🐙 Cloning AnySync repo..."
cd /root
git clone https://github.com/anyproto/any-sync-dockercompose.git
cd any-sync-dockercompose

echo "📝 Creating .env.override.prod file..."
cat <<EOF > .env.override.prod
AWS_ACCESS_KEY_ID=${ACCESS_KEY}
AWS_SECRET_ACCESS_KEY=${SECRET_KEY}
EXTERNAL_LISTEN_HOSTS=${HOST}
EOF

echo "🚀 Running make to start services..."
make start

echo "✅ Waiting for services to fully start... script will run automatically"
sleep 30

echo "🛑 Stopping services after initial setup..."
make stop

echo "🧱 Creating systemd service for autostart..."
cat <<EOF | sudo tee /etc/systemd/system/anysync.service > /dev/null
[Unit]
Description=AnySync Server
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
WorkingDirectory=/root/any-sync-dockercompose
ExecStart=/usr/bin/make start
RemainAfterExit=true
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable anysync.service

echo "🛡️ Configuring UFW firewall..."
sudo ufw allow 22/tcp
sudo ufw allow 1001:1006/tcp
sudo ufw --force enable

echo "✅ Setup complete! You can now run: sudo systemctl start anysync.service"
echo "📁 Your client.yml file will be at: /root/any-sync-dockercompose/etc/client.yml"
echo "🔐 Access & Secret Key for Minio can be found in: /root/any-sync-dockercompose/.env.override.prod"

read -p "👀 Do you want to view your client.yml now? (yes/no): " SHOW_YML
if [[ "$SHOW_YML" == "yes" || "$SHOW_YML" == "y" ]]; then
  echo ""
  echo "📄 --- BEGIN client.yml START COPY FROM THE NEXT LINE ON---"
  cat /root/any-sync-dockercompose/etc/client.yml
  echo "📄 --- END client.yml UNTIL THE LINE ABOVE---"
fi
