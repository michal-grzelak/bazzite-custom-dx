#!/usr/bin/env bash

# SCRIPT VERSION 2
# This script adds wheel members to docker, libvirt, and incus-admin groups
# Version 2 adds incus-admin support and uses append_group for idempotent operations

GROUP_SETUP_VER=2
GROUP_SETUP_VER_FILE="/etc/ublue/dx-groups"
GROUP_SETUP_VER_RAN=$(cat "$GROUP_SETUP_VER_FILE" 2>/dev/null || echo "")

# Run script if updated
if [[ -f "$GROUP_SETUP_VER_FILE" && "$GROUP_SETUP_VER" = "$GROUP_SETUP_VER_RAN" ]]; then
    echo "Group setup has already run (version $GROUP_SETUP_VER). Exiting..."
    exit 0
fi

echo "Running group setup version $GROUP_SETUP_VER..."

# Function to append user to group if not already a member
append_group() {
    local user="$1"
    local group="$2"
    
    # Check if user is already in group
    if id -nG "$user" | grep -qw "$group"; then
        echo "User $user is already in group $group"
        return
    fi
    
    # Get group info from /usr/lib/group (Atomic standard)
    local group_info
    group_info=$(grep "^${group}:" /usr/lib/group 2>/dev/null)
    
    if [[ -n "$group_info" ]]; then
        # Use usermod to append (works with shadow GID)
        usermod -aG "$group" "$user" 2>/dev/null || echo "Warning: Could not add $user to $group"
    else
        # Fallback - just try usermod
        usermod -aG "$group" "$user" 2>/dev/null || echo "Warning: Could not add $user to $group"
    fi
}

# Get all wheel users
wheel_users=$(getent group wheel | cut -d ":" -f 4 | tr ',' '\n')

# Add wheel users to groups
for user in $wheel_users; do
    echo "Processing user: $user"
    append_group "$user" docker
    append_group "$user" libvirt
    append_group "$user" incus-admin
done

# Create state file to prevent future executions
echo "Writing state file..."
echo "$GROUP_SETUP_VER" > "$GROUP_SETUP_VER_FILE"

echo "Group setup version $GROUP_SETUP_VER complete."
