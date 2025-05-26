#!/bin/bash

# Color definitions (copied from ohzsh.sh)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

show_banner() {
    echo -e "${CYAN}"
    echo "╔═════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                             ║"
    echo "║    ██████╗ ██╗  ██╗ ██████╗ ██╗  ██╗███████╗███████╗██╗  ██╗                ║"
    echo "║   ██╔═████╗╚██╗██╔╝██╔═══██╗██║  ██║╚══███╔╝██╔════╝██║  ██║                ║"
    echo "║   ██║██╔██║ ╚███╔╝ ██║   ██║███████║  ███╔╝ ███████╗███████║                ║"
    echo "║   ████╔╝██║ ██╔██╗ ██║   ██║██╔══██║ ███╔╝  ╚════██║██╔══██║                ║"
    echo "║   ╚██████╔╝██╔╝ ██╗╚██████╔╝██║  ██║███████╗███████║██║  ██║                ║"
    echo "║    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝                ║"
    echo "║                                                                             ║"
    echo -e "║                    ${MAGENTA}🚀 Blockcast BEACON Installer 🚀${CYAN}                        ║"
    echo "║                                                                             ║"
    echo -e "║                     ${YELLOW}https://blockcast.network${CYAN}                              ║"
    echo "║                                                                             ║"
    echo "║              Secure, Decentralized, Reliable Node Operation                 ║"
    echo "║                                                                             ║"
    echo "╚═════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/debian_version ]] || command -v apt &> /dev/null; then
    OS="debian"
fi

# Docker install function
install_docker() {
    if command -v docker &> /dev/null; then
        print_status "Docker is already installed."
        return
    fi
    print_status "Docker not found. Installing Docker..."
    if [[ "$OS" == "macos" ]]; then
        print_status "Please install Docker Desktop from https://www.docker.com/products/docker-desktop/ and start it."
        exit 1
    elif [[ "$OS" == "debian" ]]; then
        sudo apt update
        sudo apt install -y ca-certificates curl gnupg lsb-release
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker "$USER"
        print_status "Docker installed. Please log out and log back in for group changes to take effect."
    else
        print_error "Unsupported OS for automatic Docker installation."
        exit 1
    fi
}

# Clone docker compose repo if not present
clone_compose_repo() {
    if [ ! -d "beacon-docker-compose" ]; then
        print_status "Cloning Blockcast BEACON docker compose repo..."
        git clone https://github.com/Blockcast/beacon-docker-compose.git
    else
        print_status "beacon-docker-compose directory already exists."
    fi
}

# Start docker compose
start_beacon() {
    cd beacon-docker-compose || { print_error "beacon-docker-compose directory not found."; exit 1; }
    print_status "Starting Blockcast BEACON via docker compose..."
    docker compose up -d
    print_status "Blockcast BEACON started."
    cd ..
}

# Initialize and show node id
show_node_id() {
    cd beacon-docker-compose || { print_error "beacon-docker-compose directory not found."; exit 1; }
    print_status "Initializing Blockcast BEACON to get Hardware ID and Challenge Key..."
    docker compose exec blockcastd blockcastd init
    cd ..
}

# Main logic
show_banner

if [[ "$1" == "--show-node-id" ]]; then
    show_node_id
    exit 0
fi

install_docker
clone_compose_repo
start_beacon
sleep 5
show_node_id
