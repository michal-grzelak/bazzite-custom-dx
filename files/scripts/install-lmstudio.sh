#!/usr/bin/env bash
# Install LM Studio from AppImage
# TEMPORARY OVERRIDE: AppImage-based installation (no RPM available)

set -e

LMSTUDIO_VERSION="latest"
LMSTUDIO_DIR="/opt/lmstudio"
LMSTUDIO_URL="https://releases.lmstudio.ai/${LMSTUDIO_VERSION}/linux/x86/LM-Studio-${LMSTUDIO_VERSION}.AppImage"

echo "Downloading LM Studio..."

# Download LM Studio AppImage
mkdir -p "$LMSTUDIO_DIR"
cd "$LMSTUDIO_DIR"

# Try to get the latest version URL if "latest" doesn't work
if [ "$LMSTUDIO_VERSION" = "latest" ]; then
    # Get actual latest version from API
    LMSTUDIO_URL=$(curl -s https://releases.lmstudio.ai/latest/linux/x86/latest.txt 2>/dev/null || echo "https://releases.lmstudio.ai/linux/x86/LM-Studio-0.3.1.AppImage")
    if [[ ! "$LMSTUDIO_URL" =~ ^https?:// ]]; then
        LMSTUDIO_URL="https://releases.lmstudio.ai/${LMSTUDIO_URL}/linux/x86/LM-Studio-${LMSTUDIO_URL}.AppImage"
    fi
fi

wget -O lmstudio.AppImage "$LMSTUDIO_URL"

# Make executable
chmod +x lmstudio.AppImage

# Extract AppImage for chrome-sandbox permissions
echo "Extracting AppImage..."
./lmstudio.AppImage --appimage-extract >/dev/null 2>&1

# Fix chrome-sandbox permissions for GPU acceleration
if [ -d squashfs-root ]; then
    if [ -f squashfs-root/chrome-sandbox ]; then
        chown root:root squashfs-root/chrome-sandbox
        chmod 4755 squashfs-root/chrome-sandbox
    fi
    
    # Move squashfs-root contents to LM Studio directory
    mv squashfs-root/* "$LMSTUDIO_DIR/" 2>/dev/null || true
    rm -rf squashfs-root
fi

# Create desktop entry
mkdir -p /usr/share/applications
cat > /usr/share/applications/lmstudio.desktop << 'EOF'
[Desktop Entry]
Name=LM Studio
Comment=Local LLM development and inference
Exec=lmstudio %U
Icon=lmstudio
Terminal=false
Type=Application
Categories=Development;AI;
MimeType=x-scheme-handler/lmstudio;
EOF

# Add lmstudio to PATH by creating symlink in /usr/local/bin
ln -sf "$LMSTUDIO_DIR/lmstudio" /usr/local/bin/lmstudio 2>/dev/null || true
ln -sf "$LMSTUDIO_DIR/lms" /usr/local/bin/lms 2>/dev/null || true

# Bootstrap lms CLI
if [ -x "$LMSTUDIO_DIR/lms" ]; then
    echo "Bootstrapping lms CLI..."
    "$LMSTUDIO_DIR/lms" bootstrap || true
fi

echo "LM Studio installed successfully to $LMSTUDIO_DIR"
