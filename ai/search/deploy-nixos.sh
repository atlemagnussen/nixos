#!/bin/bash
# Deploy AI Search to NixOS

set -e

echo "🚀 Deploying AI Product Search to NixOS..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if running on NixOS
if ! [ -f /etc/os-release ] || ! grep -q "NixOS" /etc/os-release; then
    echo "⚠️  This script is designed for NixOS"
    echo "Continuing anyway..."
fi

echo ""
echo "📝 To enable this on your NixOS system:"
echo ""
echo "1. Add to your /etc/nixos/configuration.nix:"
echo "   imports = [ ${SCRIPT_DIR}/ai-search.nix ];"
echo ""
echo "2. Rebuild your NixOS configuration:"
echo "   sudo nixos-rebuild switch"
echo ""
echo "3. Enable and start the service:"
echo "   sudo systemctl enable ai-search-pod"
echo "   sudo systemctl start ai-search-pod"
echo ""
echo "4. Check service status:"
echo "   sudo systemctl status ai-search-pod"
echo "   sudo journalctl -u ai-search-pod -f"
echo ""
echo "5. Download the model:"
echo "   cd ${SCRIPT_DIR}"
echo "   ./download-model.sh"
echo ""
echo "6. Access the web UI:"
echo "   http://localhost:8000/static/index.html"
echo ""
