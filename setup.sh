#!/bin/bash
set -e

echo "=== Updating system packages ==="
apt-get update -y
apt-get install -y xfce4 xfce4-goodies tightvncserver novnc python3-websockify net-tools curl dbus-x11

echo "=== Configuring VNC Password ==="
mkdir -p ~/.vnc
# Default password: password123 (Change this if needed!)
echo "password123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "=== Configuring XFCE Startup ==="
cat << 'EOF' > ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "=== Starting VNC Server ==="
vncserver -kill :1 2>/dev/null || true
vncserver :1 -geometry 1280x720 -depth 24

# CloudClusters exposes incoming web traffic on $PORT (or 8080 by default)
PORT=${PORT:-8080}

echo "=== Launching noVNC Web Interface on Port $PORT ==="
exec /usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen $PORT
