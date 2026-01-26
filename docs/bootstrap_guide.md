# Ninja Fleet Bootstrap Guide

This guide will help you set up the Ninja Fleet infrastructure from scratch.

## 0. Initial Repository Setup (First Time Only)

If you just cloned this repository, you need to configure it with your personal settings:

### Step 1: Set Up Inventory

Copy the example inventory file and customize it with your hosts:

```bash
cp inventory/hosts.example.ini inventory/hosts.ini
```

Edit `inventory/hosts.ini` to add your actual:

- Hostnames
- IP addresses or DNS names
- Group assignments (`[homelab]`, `[workstation]`, `[personal]`, etc.)
- Any host-specific variables (e.g., `ansible_user`, `wireguard_peer`)

### Step 2: Configure Global Variables

Copy the example global variables file and customize it:

```bash
cp inventory/group_vars/all/main.example.yml inventory/group_vars/all/main.yml
```

Edit `inventory/group_vars/all/main.yml` to set your:

- Admin username
- Primary domain
- User full name and email
- Git signing key
- Server hostname and IPs

### Step 3: Set Up Vault Password

Choose one of the following methods:

#### Option A: 1Password CLI integration (recommended)

```bash
cp vault_1password.example.sh vault_1password.sh
chmod +x vault_1password.sh
```

Edit `vault_1password.sh` and replace the placeholders with your actual 1Password vault, item, and field names (or UUIDs). See the [1Password CLI documentation](https://developer.1password.com/docs/cli/) for more details.

#### Option B: Plain text file

```bash
echo "your-vault-password" > ~/.ansible_vault_pass
chmod 600 ~/.ansible_vault_pass
```

### Step 4: Create Encrypted Secrets File

Create the secrets file to store sensitive data:

```bash
ansible-vault create inventory/group_vars/all/secrets.yml
```

Add your sensitive variables like API keys, passwords, etc.

> [!TIP]
> All actual configuration files (`hosts.ini`, `main.yml`, `secrets.yml`, `vault_1password.sh`, `compose.yml`) are already in `.gitignore` to keep your personal data private. For an automated way to manage these across machines, see the [Private Config Management guide](private_config_management.md).

---

## 1. Enable SSH (Remote Login)

Since Ansible communicates over SSH, you need to ensure it is enabled and your keys are authorized on every host before running the playbook.

### 🍏 macOS

Run this command in the terminal of the target Mac:

```bash
sudo systemsetup -setremotelogin on
```

_Alternatively, go to **System Settings > General > Sharing** and toggle **Remote Login** to ON._

### 🐧 Linux (Debian, Fedora, Arch)

Run this command on the target Linux machine:

```bash
sudo systemctl enable --now ssh
```

### 📱 Android (Google Pixel)

Ansible uses **ADB** (Android Debug Bridge) over USB instead of SSH.

1. **Enable Developer Options**: Settings > About Phone > Tap "Build Number" 7 times.
2. **Enable USB Debugging**: Settings > System > Developer Options > Toggle **USB Debugging** to ON.
3. **Trust your Mac**: Connect the phone to your Mac via USB and tap **Allow** on the "Allow USB Debugging?" prompt.

### 🪟 Windows 11

Ansible uses the built-in **OpenSSH Server**.

1. **Enable OpenSSH**: Settings > Apps > Optional features > Add a feature > **OpenSSH Server**.
2. **Start Service**: Open PowerShell as Administrator and run:

   ```powershell
   Start-Service sshd; Set-Service -Name sshd -StartupType 'Automatic'
   ```

3. **Key Exchange**: Copy your key from your Mac:

   ```bash
   ssh-copy-id <username>@<windows-ip>
   ```

   _(Note: On Windows, keys are stored in `C:\Users\<user>\.ssh\authorized_keys`)_.

---

## 2. Copy Your SSH Key

From your primary workstation (e.g., `workstation-1`), copy your public key to the new host to allow passwordless access:

```bash
ssh-copy-id <username>@<new-host-ip>
```

---

## 3. Verify Connectivity

Test that you can log in without a password:

```bash
ssh <username>@<new-host-ip>
```

---

## 4. Managing Different Usernames

If your fleet uses different usernames (e.g., `user1` on one Mac, `admin` on another), you can define them host-by-host in the inventory.

### Option A: In hosts.ini

Add the `ansible_user` variable directly to the host line:

```ini
workstation-1 ansible_host=192.168.1.2 ansible_user=user1
workstation-2 ansible_host=192.168.1.3 ansible_user=admin
```

### Option B: In host_vars

Create `inventory/host_vars/<hostname>.yml` and set the variable there:

```yaml
ansible_user: user1
```

---

## 5. Managing Different Sudo Passwords

If your hosts have different passwords, you have three options:

### Option A: Passwordless Sudo (Highly Recommended)

The cleanest way to automate is to allow your user to run `sudo` without a password. Run this command on the target host (it automatically uses your current logged-in username):

```bash
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
```

> [!NOTE]
> This creates a small file in `/etc/sudoers.d/` that tells the system: "Let this specific user run any command with sudo without asking for a password."

### Option B: Per-Host Variables (Encrypted with Vault)

You can define the password for a specific host in `inventory/host_vars/<hostname>.yml`:

```yaml
ansible_become_password: "YOUR_SECRET_PASSWORD"
```

> [!IMPORTANT]
> **Never store plain-text passwords in Git.** Use `ansible-vault encrypt inventory/host_vars/<hostname>.yml` to keep them secure.

### Option C: The manual way (-K)

Using the `-K` flag in your command will prompt you once. **This only works if all hosts in the current run share the same password.**

---

## 5. Configure Ansible Vault Password

This project uses **Ansible Vault** to encrypt sensitive data. Before running the playbook, you need to set up the vault password:

### Option A: Use 1Password CLI (Recommended)

If you use 1Password, you can retrieve the vault password dynamically. See [`vault_1password.example.sh`](../vault_1password.example.sh) for examples:

1. Copy the example file or use `link-config.sh` to sync it from your private storage.

2. Ensure your `vault_1password.sh` is executable and points to the correct field in your vault.

3. Make it executable:

   ```bash
   chmod +x vault_1password.sh
   ```

4. Configure Ansible to use it by setting the vault password file in `ansible.cfg` or using the `--vault-password-file` flag.

> [!TIP]
> Using 1Password CLI keeps your vault password secure and avoids storing it in plain text on disk.

### Option B: Store in a File

Create a file at `~/.ansible_vault_pass` containing your vault password:

```bash
echo "your-vault-password" > ~/.ansible_vault_pass
chmod 600 ~/.ansible_vault_pass
```

---

## 6. Run the Playbook

Once connectivity and credentials are confirmed, add the host to `inventory/hosts.ini` and run:

```bash
ansible-playbook site.yml -K --limit <new-host-name>
```
