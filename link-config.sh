#!/bin/bash
# link-config.sh
# Use this script to link your private configuration files from a secure location
# into the ninja-fleet directory.

set -e

# Default source directory (customize this)
SOURCE_DIR="${1:-$HOME/.config/ninja-fleet}"
USE_SYMLINKS=true

# Check for --copy flag
for arg in "$@"; do
    if [ "$arg" == "--copy" ]; then
        USE_SYMLINKS=false
    fi
done

if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: Source directory '$SOURCE_DIR' not found."
    echo "Usage: ./link-config.sh [path_to_private_config_repo] [--copy]"
    exit 1
fi

if [ "$USE_SYMLINKS" = true ]; then
    echo "🔗 Linking private configurations from $SOURCE_DIR..."
    ACTION="ln -sfn"
else
    echo "🚀 Copying private configurations from $SOURCE_DIR..."
    ACTION="cp"
fi

# Function to perform the sync action
sync_item() {
    local src="$1"
    local dest="$2"
    if [ -e "$src" ]; then
        # Safety: Never link a file to itself
        local abs_src abs_dest
        abs_src=$(realpath "$src")
        if [ -e "$dest" ]; then
            abs_dest=$(realpath "$dest")
            if [ "$abs_src" == "$abs_dest" ]; then
                echo "⏭️ Skipping $dest (already points to source)"
                return
            fi
        fi

        mkdir -p "$(dirname "$dest")"
        if [ "$USE_SYMLINKS" = true ]; then
            $ACTION "$abs_src" "$dest"
        else
            $ACTION "$src" "$dest"
        fi
    fi
}

# 1. Inventory and Vars
sync_item "$SOURCE_DIR/hosts.ini" "inventory/hosts.ini"
sync_item "$SOURCE_DIR/main.yml" "inventory/group_vars/all/main.yml"
sync_item "$SOURCE_DIR/secrets.yml" "inventory/group_vars/all/secrets.yml"

# 2. Vault Password Script
sync_item "$SOURCE_DIR/vault_1password.sh" "./vault_1password.sh"

# 3. SSL Certificates
if [ -d "$SOURCE_DIR/certs" ]; then
    mkdir -p roles/homelab/files/certs
    for cert_file in "$SOURCE_DIR/certs"/*; do
        if [ -f "$cert_file" ]; then
            file_name=$(basename "$cert_file")
            sync_item "$cert_file" "roles/homelab/files/certs/$file_name"
        fi
    done
fi

# 4. Homelab Compose Files
sync_item "$SOURCE_DIR/compose.yml" "roles/homelab/files/compose.yml"

# 5. Service-specific Compose Files
if [ -d "$SOURCE_DIR/services" ]; then
    for service_dir in "$SOURCE_DIR/services"/*; do
        if [ -d "$service_dir" ]; then
            service_name=$(basename "$service_dir")
            sync_item "$service_dir/compose.yml" "roles/homelab/files/services/$service_name/compose.yml"
        fi
    done
fi

echo "✨ Sync complete! Files are ready but ignored by git."
