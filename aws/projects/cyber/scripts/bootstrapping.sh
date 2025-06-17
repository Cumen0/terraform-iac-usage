#!/bin/bash

# Enable error reporting
set -e
set -o pipefail

# Function for error handling
handle_error() {
    echo "Error occurred in script at line $1"
    echo "Command that failed: $2"
    echo "Exit code: $3"
    exit 1
}

# Set up error handling
trap 'handle_error ${LINENO} "$BASH_COMMAND" $?' ERR

# Print script start
echo "Starting script execution at $(date)"

# Check if running in userdata or manually
if [ -f /var/lib/cloud/instance/boot-finished ]; then
    echo "Running in manual mode - cloud-init already completed"
else
    echo "Waiting for cloud-init to complete..."
    cloud-init status --wait || {
        echo "Failed to wait for cloud-init"
        exit 1
    }
fi

# Update and upgrade packages
echo "Updating and upgrading packages..."
apt-get update || {
    echo "Failed to update package lists"
    exit 1
}

DEBIAN_FRONTEND=noninteractive apt-get upgrade -y || {
    echo "Failed to upgrade packages"
    exit 1
}

# Install required packages
echo "Installing required packages..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    htop || {
    echo "Failed to install required packages"
    exit 1
}

# Install Docker
echo "Installing Docker..."
# Create directory for Docker's GPG key
mkdir -p /etc/apt/keyrings || {
    echo "Failed to create /etc/apt/keyrings directory"
    exit 1
}

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg || {
    echo "Failed to add Docker's GPG key"
    exit 1
}

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null || {
    echo "Failed to add Docker repository"
    exit 1
}

# Update package index
echo "Updating package index..."
apt-get update || {
    echo "Failed to update package index"
    exit 1
}

# Install Docker and related packages
echo "Installing Docker packages..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin || {
    echo "Failed to install Docker packages"
    exit 1
}

# Add Docker group and add ubuntu user to it
echo "Setting up Docker group..."
groupadd -f docker || {
    echo "Failed to create docker group"
    exit 1
}

usermod -aG docker ubuntu || {
    echo "Failed to add ubuntu user to docker group"
    exit 1
}

# Enable and start Docker services
echo "Starting Docker services..."
systemctl enable docker.service || {
    echo "Failed to enable docker service"
    exit 1
}
systemctl enable containerd.service || {
    echo "Failed to enable containerd service"
    exit 1
}
systemctl start docker.service || {
    echo "Failed to start docker service"
    exit 1
}
systemctl start containerd.service || {
    echo "Failed to start containerd service"
    exit 1
}

# Wait for Docker to be ready
echo "Waiting for Docker to be ready..."
timeout=30
while ! docker info >/dev/null 2>&1; do
    if [ $timeout -le 0 ]; then
        echo "Timeout waiting for Docker to start"
        exit 1
    fi
    timeout=$((timeout-1))
    sleep 1
done

# Print Docker and Docker Compose versions
echo "Docker version:"
docker --version || {
    echo "Failed to get Docker version"
    exit 1
}
echo "Docker Compose version:"
docker compose version || {
    echo "Failed to get Docker Compose version"
    exit 1
}

# Create Jenkins home directory
echo "Setting up Jenkins..."
JENKINS_HOME="/var/jenkins_home"
mkdir -p $JENKINS_HOME || {
    echo "Failed to create Jenkins home directory"
    exit 1
}
chmod 755 $JENKINS_HOME || {
    echo "Failed to set permissions on Jenkins home directory"
    exit 1
}

# Create docker-compose.yml for Jenkins
echo "Creating docker-compose.yml..."
cat > $JENKINS_HOME/docker-compose.yml << 'EOF'
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: unless-stopped
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    volumes:
      - /var/jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
EOF

# Start Jenkins container
echo "Starting Jenkins container..."
cd $JENKINS_HOME || {
    echo "Failed to change to Jenkins home directory"
    exit 1
}
docker compose up -d || {
    echo "Failed to start Jenkins container"
    exit 1
}

# Create a completion flag file
echo "Creating completion flag..."
touch /var/log/user-data-complete.log || {
    echo "Failed to create completion flag"
    exit 1
}
echo "Installation completed successfully at $(date)" >> /var/log/user-data-complete.log

# Clean up
echo "Cleaning up..."
apt-get clean || {
    echo "Failed to clean apt cache"
    exit 1
}
rm -rf /var/lib/apt/lists/* || {
    echo "Failed to remove apt lists"
    exit 1
}

# Print final status
echo "Docker installation completed"
echo "Jenkins container started"
echo "You can access Jenkins at http://$(curl -s http://169.254.169.254/latest/meta-data/public-hostname):8080"

# Print system status
echo "System status:"
systemctl status docker.service --no-pager
docker ps
