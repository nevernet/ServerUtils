#!/bin/bash

DNS1=${1:-100.90.90.90}
DNS2=${2:-100.90.90.100}

echo "=========================================="
echo "DNS Persistent Configuration Script"
echo "=========================================="
echo "DNS servers: $DNS1, $DNS2"
echo

read -p "This will disable systemd-resolved and configure static DNS. Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo "[1/4] Stopping systemd-resolved..."
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
echo "  Done."

echo "[2/4] Backing up resolv.conf..."
if [ -f /etc/resolv.conf ]; then
    sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    echo "  Backup: /etc/resolv.conf.bak"
fi

echo "[3/4] Creating static resolv.conf..."
echo "nameserver $DNS1
nameserver $DNS2" | sudo tee /etc/resolv.conf > /dev/null

echo "[4/4] Locking resolv.conf to prevent modification..."
sudo chattr +i /etc/resolv.conf

echo
echo "=========================================="
echo "Configuration complete!"
echo "=========================================="
echo "Current resolv.conf:"
cat /etc/resolv.conf
echo
echo "To unlock (for future modifications):"
echo "  sudo chattr -i /etc/resolv.conf"
echo

echo "Testing DNS..."
if ping -c 1 mirrors.ucloud.cn > /dev/null 2>&1; then
    echo "  DNS resolution: OK"
else
    echo "  DNS resolution: FAILED"
fi

if ping -c 1 google.com > /dev/null 2>&1; then
    echo "  Internet connectivity: OK"
else
    echo "  Internet connectivity: FAILED"
fi
