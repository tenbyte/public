#!/bin/bash

# === CONFIG ===
MINIO_USER="minio-user"
MINIO_DIR="/data/minio"
MINIO_BINARY_URL="https://dl.min.io/server/minio/release/linux-amd64/minio"
MINIO_ROOT_USER="admin"
MINIO_ROOT_PASSWORD=$(openssl rand -base64 16)
CONSOLE_PORT=9001
API_PORT=9000

echo "==== ⚙️  MinIO Installer for Ubuntu ===="

# === DISCLAIMER ===
echo
echo "DISCLAIMER:"
echo "This script installs MinIO as a system service on your machine. (Debian/Ubuntu)"
echo "Use at your own risk. The author assumes no responsibility for any"
echo "losses, data corruption, or system damage caused by this script."
echo
read -p "Type YES to continue: " confirm
if [ "$confirm" != "YES" ]; then
  echo "Aborted by user."
  exit 1
fi

# === System updates and dependencies ===
sudo apt update && sudo apt install -y wget openssl

# === Create system user ===
echo "[+] Creating system user $MINIO_USER..."
sudo useradd -r $MINIO_USER -s /sbin/nologin

# === Prepare data directory ===
echo "[+] Creating data directory $MINIO_DIR..."
sudo mkdir -p $MINIO_DIR
sudo chown -R $MINIO_USER:$MINIO_USER $MINIO_DIR

# === Download and install MinIO binary ===
echo "[+] Downloading MinIO binary..."
wget -q $MINIO_BINARY_URL -O minio
chmod +x minio
sudo mv minio /usr/local/bin/

# === Store access credentials ===
echo "[+] Writing credentials to /etc/default/minio..."
echo "MINIO_ROOT_USER=$MINIO_ROOT_USER" | sudo tee /etc/default/minio > /dev/null
echo "MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD" | sudo tee -a /etc/default/minio > /dev/null

# === Create systemd service file ===
echo "[+] Creating systemd service file..."
cat <<EOF | sudo tee /etc/systemd/system/minio.service > /dev/null
[Unit]
Description=MinIO
Documentation=https://min.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
User=$MINIO_USER
Group=$MINIO_USER
ExecStart=/usr/local/bin/minio server $MINIO_DIR --console-address ":$CONSOLE_PORT" --address ":$API_PORT"
EnvironmentFile=/etc/default/minio
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# === Enable and start MinIO ===
echo "[+] Enabling and starting MinIO service..."
sudo systemctl daemon-reload
sudo systemctl enable minio
sudo systemctl start minio

# === Output credentials and info ===
echo
echo "✅ MinIO was installed successfully!"
echo "🔐 Access credentials:"
echo "   Username: $MINIO_ROOT_USER"
echo "   Password: $MINIO_ROOT_PASSWORD"
echo
echo "🌍 Access it here:"
echo "   API:     http://<your-server-ip>:$API_PORT"
echo "   Console: http://<your-server-ip>:$CONSOLE_PORT"
echo
