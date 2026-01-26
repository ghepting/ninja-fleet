#!/bin/bash
# export-config.sh
# Use this script to export your current gitignored configuration files
# into a secure location (default: ~/.config/ninja-fleet) before publishing.

set -e

# Default destination directory
DEST_DIR="${1:-$HOME/.config/ninja-fleet}"

echo "🚀 Exporting private configurations to $DEST_DIR..."
mkdir -p "$DEST_DIR"

# Helper function to copy only if not a symlink
export_item() {
    local src="$1"
    local dest="$2"

    if [ -L "$src" ]; then
        echo "⏭️ Skipping $src (already a symbolic link)"
        return
    fi

    if [ -f "$src" ]; then
        cp "$src" "$dest"
    elif [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -r "$src/"* "$dest/"
    fi
}

# 1. Inventory and Vars
export_item "inventory/hosts.ini" "$DEST_DIR/hosts.ini"
export_item "inventory/group_vars/all/main.yml" "$DEST_DIR/main.yml"
export_item "inventory/group_vars/all/secrets.yml" "$DEST_DIR/secrets.yml"

# 2. Vault Password Script
export_item "vault_1password.sh" "$DEST_DIR/vault_1password.sh"

# 3. SSL Certificates
if [ -d "roles/homelab/files/certs" ]; then
    mkdir -p "$DEST_DIR/certs"
    for cert_file in roles/homelab/files/certs/*; do
        if [ -f "$cert_file" ]; then
            file_name=$(basename "$cert_file")
            # Skip example files and .gitkeep
            if [[ "$file_name" == *.example.* ]] || [[ "$file_name" == ".gitkeep" ]]; then
                continue
            fi
            export_item "$cert_file" "$DEST_DIR/certs/$file_name"
        fi
    done
fi

# 4. Homelab Compose Files
export_item "roles/homelab/files/compose.yml" "$DEST_DIR/compose.yml"

# 5. Service-specific Compose Files
for service_dir in roles/homelab/files/services/*; do
    if [ -d "$service_dir" ]; then
        service_name=$(basename "$service_dir")
        if [ -f "$service_dir/compose.yml" ]; then
            mkdir -p "$DEST_DIR/services/$service_name"
            export_item "$service_dir/compose.yml" "$DEST_DIR/services/$service_name/compose.yml"
        fi
    fi
done

echo "✨ Export complete! You can now safely push your public repo."
echo "Use ./link-config.sh to pull these files back in on any machine."
