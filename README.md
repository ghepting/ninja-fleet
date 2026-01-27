# 🦅 Ninja Fleet - Unified Orchestration

![CI](https://github.com/ghepting/ninja-fleet/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-green)
![Ansible](https://img.shields.io/badge/ansible-%3E%3D2.10-D30C55?logo=ansible)
[![GitHub](https://img.shields.io/badge/github-%23121011.svg?logo=github&logoColor=white)](https://github.com/ghepting/ninja-fleet)

A robust, cross-platform Ansible infrastructure for managing a personal ecosystem of homelab servers, workstations (macOS/Linux), personal laptops, and Android devices.

## 🏮 Philosophy

Ninja Fleet was born from years of manual bash scripts, half-documented config files, and the recurring frustration of "how did I set that up last time?"

It represents an evolution from ad-hoc "search and destroy" maintenance to an immutable, unified "fleet" mindset. Whether it's a headless Debian server, a high-end macOS workstation, or a Windows media box, this repo ensures a consistent, secure, and reproducible environment through trial-and-error hardened logic.

## ✨ Features

- **Multi-OS Orchestration**: Unified management of macOS, Debian/Ubuntu, Windows 11, and Android (via ADB).
- **Homelab Stack**: Automated Docker deployments for Caddy, WireGuard, Technitium DNS, and more.
- **Developer Workstation**: Automated setup of dotfiles, dev tools (zsh, vim, tmux), and GUI applications via Homebrew/Flatpak.
- **Surgical VPN**: Integrated WireGuard orchestration for secure remote access across all devices.
- **Mobile Check-ins**: Basic Android management including app verification and VPN health checks.
- **Production Standards**: Enforced idempotency, strict linting, and Molecule-tested core roles.
- **Automated Releases**: Standardized via Conventional Commits and Release Please.

## 📐 Architecture

```text
                     ┌───────────────────┐
                     │   Control Machine │ (Your Workstation)
                     └─────────┬─────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                  │
    ┌───────▼───────┐  ┌───────▼───────┐  ┌───────▼───────┐
    │    Homelab    │  │  Workstations │  │  Plex Server  │
    │    (Linux)    │  │ (macOS/Linux) │  │   (Windows)   │
    └───────┬───────┘  └───────┬───────┘  └───────────────┘
            │                  │
    ┌───────▼───────┐  ┌───────▼───────┐
    │ Docker Stack  │  │   Dev Tools   │
    │ (Caddy/VPN)   │  │ (Vim/Zsh/SSH) │
    └───────────────┘  └───────────────┘
```

## 🚀 Quick Start

### Initial Setup (First Time Only)

If you're cloning this repository for the first time, you'll need to set up your configuration files:

1. **Copy the inventory template**:

   ```bash
   cp inventory/hosts.example.ini inventory/hosts.ini
   ```

   Edit `inventory/hosts.ini` to add your actual hostnames and IP addresses.

2. **Copy the global variables template**:

   ```bash
   cp inventory/group_vars/all/main.example.yml inventory/group_vars/all/main.yml
   ```

   Edit `inventory/group_vars/all/main.yml` to set your personal information:
   - `primary_domain` - Your domain name
   - `user_email` - Your email address
   - `admin_username` - Your primary username
   - Network settings (IPs, subnets, interface names)
   - Service configurations (WireGuard, Plex, etc.)

3. **Set up homelab service configurations** (if using the homelab role):

   ```bash
   # Main compose file
   cp roles/homelab/files/compose.example.yml roles/homelab/files/compose.yml

   # Service-specific compose files (templates will generate these automatically)
   # Or manually copy if needed:
   # cp roles/homelab/files/services/*/compose.example.yml roles/homelab/files/services/*/compose.yml
   ```

   Edit `compose.yml` to add any custom Docker networks (e.g., for external services).

4. **Configure SSL certificates** (if using Caddy with HTTPS):

   Place your SSL certificate files in `roles/homelab/files/certs/`:

   ```bash
   # Use the examples as templates
   cp roles/homelab/files/certs/your-domain.example.crt roles/homelab/files/certs/your-domain.crt
   cp roles/homelab/files/certs/your-domain.example.key roles/homelab/files/certs/your-domain.key
   ```

   > [!TIP]
   > Caddy can automatically obtain Let's Encrypt certificates. The manual certs are only needed if you prefer to use pre-existing certificates.

5. **Set up Ansible Vault password** (choose one):
   - **Option A**: Use 1Password CLI (recommended)

     ```bash
     # Copy and customize the example
     cp vault_1password.example.sh vault_1password.sh
     chmod +x vault_1password.sh
     ```

     Edit `vault_1password.sh` to reference your 1Password vault item.

   - **Option B**: Create `~/.ansible_vault_pass` with your vault password

   > [!NOTE]
   > The vault script is located in the repo root (not `~/.ansible/`) so the example and your actual script are in the same place. The actual `vault_1password.sh` file is gitignored.

6. **Create encrypted secrets file**:

   ```bash
   ansible-vault create inventory/group_vars/all/secrets.yml
   ```

> [!NOTE]
> The `.gitignore` is configured to exclude your actual configuration files (`hosts.ini`, `main.yml`, `compose.yml`, certs, etc.) to keep your personal data private.

### 🔄 Managing Private Data (Overlay Workflow)

If you manage multiple machines or want to keep your private data in a separate private repository, you can use the included `link-config.sh` script.

1. Create a private folder or repository (default: `~/.config/ninja-fleet`).
2. Run the export script to move your current local configs to this location:

   ```bash
   ./export-config.sh
   ```

3. In the future, or on other machines, run the link script to "overlay" your private data:

   ```bash
   ./link-config.sh
   ```

4. This will create symlinks from your private storage into the project, ready for execution.

### Private Config Symlink Mapping

The following diagram shows how your private files in `~/.config/ninja-fleet` are mapped into the `ninja-fleet` directory:

```text
ninja-fleet/
├── inventory/
│   ├── hosts.ini ───────────────> ~/.config/ninja-fleet/hosts.ini [IGNORED]
│   └── group_vars/
│       └── all/
│           ├── main.yml ────────> ~/.config/ninja-fleet/main.yml [IGNORED]
│           └── secrets.yml ─────> ~/.config/ninja-fleet/secrets.yml [IGNORED]
├── roles/
│   └── homelab/
│       └── files/
│           ├── certs/
│           │   ├── your-domain.crt ──> ~/.config/ninja-fleet/certs/your-domain.crt [IGNORED]
│           │   └── your-domain.key ──> ~/.config/ninja-fleet/certs/your-domain.key [IGNORED]
│           ├── compose.yml ───────────> ~/.config/ninja-fleet/compose.yml [IGNORED]
│           └── services/
│               ├── <service-name>/
│               │   └── compose.yml ───> ~/.config/ninja-fleet/services/<service-name>/compose.yml [IGNORED]
│               └── caddy/
│                   ├── Caddyfile ─────> ~/.config/ninja-fleet/services/caddy/Caddyfile [IGNORED]
│                   └── compose.yml ───> ~/.config/ninja-fleet/services/caddy/compose.yml [IGNORED]
├── vault_1password.sh ──────────> ~/.config/ninja-fleet/vault_1password.sh [IGNORED]
├── link-config.sh
├── export-config.sh
└── site.yml
```

> [!TIP]
> This "Overlay" strategy allows you to keep the `ninja-fleet` repository public while keeping your sensitive host and environment configuration strictly private and separately managed.

### Prerequisites

- **Ansible** installed on your primary workstation.
- **Python 3.10+** (managed via `pyenv` recommended).
- **ADB** installed (for orchestrating Android phones).

### Running the Playbook

To run the orchestration for the entire fleet:

```bash
ansible-playbook site.yml -K
```

To target a specific host:

```bash
ansible-playbook site.yml -K --limit <hostname>
```

To run specific parts of the configuration using tags:

```bash
ansible-playbook site.yml -K --tags "shell,git"
```

## 🏗️ Project Structure

- `inventory/`: Fleet definition.
  - `hosts.ini`: Main list of hosts and groups.
  - `group_vars/`: Configuration shared by groups of hosts.
  - `host_vars/`: Overrides for specific individual hosts.
- `roles/`: Modular configuration blocks.
  - `common`: Core utilities, Docker, and shell setup shared by multiple roles.
  - `homelab`: Docker-based services (Caddy, WireGuard, Technitium, etc.).
  - `workstation`: GUI apps, dev tools, and workstation-specific tweaks for developers.
  - `personal`: Basic productivity apps (Chrome, 1Password, etc.) for non-developer machines.
  - `plex_server`: Windows 11 media server configurations (Plex, etc.).
  - `phone`: Android app checking and VPN configuration via ADB.
- `playbooks/`: Logic for different system types.
- `site.yml`: The entry point for all fleet orchestration.

## 🛠️ Management & Modification

### Adding a New Host

1. Follow the [Bootstrap Guide](docs/bootstrap_guide.md) to enable SSH/ADB.
2. Add the host entry to `inventory/hosts.ini`.
3. (Optional) Create `inventory/host_vars/<hostname>.yml` for specific user/group overrides (see `inventory/host_vars/example-host.yml.example`).
4. Run the playbook with `--limit <hostname>`.

### Managing Secrets

Sensitive data (passwords, keys) is stored in `inventory/group_vars/all/secrets.yml` and is encrypted with **Ansible Vault**.

- **Edit secrets**: `ansible-vault edit inventory/group_vars/all/secrets.yml`
- **Vault Pass**: Stored in `~/.ansible_vault_pass` (ensure this exists and is secured).
- **1Password Integration**: If you use 1Password CLI, see [`vault_1password.example.sh`](vault_1password.example.sh) for examples on how to retrieve the vault password dynamically.

### Developing Roles

This project uses **Molecule** for testing the `common` role and **ansible-lint** to enforce a "Production Profile" standard (standardized naming, shell robustness, etc.).

## 📖 Further Reading

- [Bootstrap Guide](docs/bootstrap_guide.md): Preparing new hardware.
- [Walkthrough](docs/walkthrough.md): Overview of recent project updates and logic.
- [Post-Execution Guide](docs/post_execution_guide.md): Cleanup and final verification steps.
- [Private Config Management](docs/private_config_management.md): Details on managing private configurations.

## 🛡️ Public vs Private

This repository is designed to be public-friendly. Sensitive data is handled via:

- `.gitignore`: Excludes `hosts.ini`, `main.yml`, and `secrets.yml`.
- `*.example.yml`: Provides templates for all required configuration.
- `inventory/host_vars/`: Ignores host-specific PII/overrides.
- `roles/homelab/templates/`: Jinja2 templates for sensitive compose files.

---

Created and maintained by [@ghepting](https://github.com/ghepting)
