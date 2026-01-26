# 🦅 Ninja Fleet - Unified Orchestration

A robust, cross-platform Ansible infrastructure for managing a personal ecosystem of homelab servers, workstations (macOS/Linux), personal laptops, and Android devices.

## 🚀 Quick Start

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

1. Follow the [Bootstrap Guide](.gemini/antigravity/brain/current/bootstrap_guide.md) to enable SSH/ADB.
2. Add the host entry to `inventory/hosts.ini`.
3. (Optional) Create `inventory/host_vars/<hostname>.yml` for specific user/group overrides.
4. Run the playbook with `--limit <hostname>`.

### Managing Secrets

Sensitive data (passwords, keys) is stored in `inventory/group_vars/all/secrets.yml` and is encrypted with **Ansible Vault**.

- **Edit secrets**: `ansible-vault edit inventory/group_vars/all/secrets.yml`
- **Vault Pass**: Stored in `~/.ansible_vault_pass` (ensure this exists and is secured).

### Developing Roles

This project uses **Molecule** for testing the `common` role and **ansible-lint** to enforce a "Production Profile" standard (standardized naming, shell robustness, etc.).

## 📖 Further Reading

- [Bootstrap Guide](docs/bootstrap_guide.md): Preparing new hardware.
- [Walkthrough](docs/walkthrough.md): Overview of recent project updates and logic.
- [Post-Execution Guide](docs/post_execution_guide.md): Cleanup and final verification steps.

---

Created and maintained by [@ghepting](https://github.com/ghepting)
