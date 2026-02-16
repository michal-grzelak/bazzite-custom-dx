#!/usr/bin/env bash
# Setup clblast symlinks for LM Studio
# TEMPORARY OVERRIDE: Workaround for library paths

set -e

# Find libclblast library
CLBLAST_LIB=$(find /usr -name "libclblast.so*" 2>/dev/null | head -1)

if [ -z "$CLBLAST_LIB" ]; then
    echo "clblast not found, skipping symlinks"
    exit 0
fi

# Get just the library name
LIB_NAME=$(basename "$CLBLAST_LIB")

# Create symlinks in /usr/local/lib for LM Studio to find
mkdir -p /usr/local/lib
ln -sf "$CLBLAST_LIB" "/usr/local/lib/$LIB_NAME"

# If there's a .so.1 version, also symlink that
if [[ "$LIB_NAME" == *.so.* ]]; then
    BASE_NAME="${LIB_NAME%.so.*}"
    SO_VERSION=$(echo "$LIB_NAME" | sed -n 's/.*\.so\(\.[0-9]*\).*/\1/p')
    if [ -n "$SO_VERSION" ]; then
        ln -sf "$CLBLAST_LIB" "/usr/local/lib/${BASE_NAME}.so$SO_VERSION" 2>/dev/null || true
    fi
fi

echo "Created clblast symlinks in /usr/local/lib"
