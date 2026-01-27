# Managing Private Configurations

Ninja Fleet is designed to be public-facing, which means all personal data (IPs, hostnames, domains, SSL certificates) is excluded from version control via `.gitignore`.

This guide explains how to manage your private configurations across multiple machines using the "Overlay" workflow.

## The Strategy: Separated Storage

The most robust way to manage your fleet is to maintain two locations:

1. Public Repo (`ninja-fleet`): Contains the Ansible logic, roles, and playbooks.
2. Private Storage (`~/.config/ninja-fleet`): Contains your actual `hosts.ini`, `main.yml`, `secrets.yml`, and certificate files. This can be backed up as a standalone private repository.

## Recommended File Structure

Organize your private storage as follows to maintain compatibility with the sync scripts:

```text
~/.config/ninja-fleet/
├── hosts.ini
├── main.yml
├── secrets.yml
├── vault_1password.sh
├── compose.yml
├── certs/
│   ├── example.com.crt
│   └── example.com.key
└── services/
    ├── wireguard/
    │   └── compose.yml
    └── technitium/
        └── compose.yml
```

## Automating the Migration: `export-config.sh`

If you currently have your configuration files inside the `ninja-fleet` repository (but they are gitignored), you can quickly move them to the default private storage location using:

```bash
cd ninja-fleet
./export-config.sh
```

## Syncing with `link-config.sh`

The `link-config.sh` script in the root of the public repo automates the "overlay" process. It creates symbolic links to your private files into the correct locations inside the `ninja-fleet` directory.

### Usage

```bash
cd ninja-fleet
./link-config.sh  # Defaults to ~/.config/ninja-fleet
```

### What it Syncs

- **Inventory**: `hosts.ini`
- **Global Variables**: `main.yml` and `secrets.yml`
- **Vault Script**: `vault_1password.sh`
- **SSL Certificates**: All files in `certs/`
- **Docker Compose**: Main `compose.yml` and all files in service-specific directories (Caddyfile, .env, etc.).

## Multi-Machine Workflow

When moving to a new machine:

1. Clone public repo: `git clone [public-url]`
2. Set up private storage: Clone or decrypt your private config to `~/.config/ninja-fleet`.
3. Sync: Run `./link-config.sh`
4. Execute: `ansible-playbook site.yml -K`

This ensures you always have the latest logic from the public repo and the latest configuration from your private repo, while keeping them strictly separated.
