# Ninja Fleet Bootstrap Guide

Since Ansible communicates over SSH, you need to ensure it is enabled and your keys are authorized on every host before running the playbook.

## 1. Enable SSH (Remote Login)

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

From your primary workstation (`ninja-mbp`), copy your public key to the new host to allow passwordless access:

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

If your fleet uses different usernames (e.g., `gary` on one Mac, `admin` on another), you can define them host-by-host in the inventory.

### Option A: In hosts.ini

Add the `ansible_user` variable directly to the host line:

```ini
ninja-mbp ansible_host=192.168.1.10 ansible_user=gary
other-mac  ansible_host=192.168.1.11 ansible_user=admin
```

### Option B: In host_vars

Create `inventory/host_vars/<hostname>.yml` and set the variable there:

```yaml
ansible_user: gary
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

## 5. Run the Playbook

Once connectivity and credentials are confirmed, add the host to `inventory/hosts.ini` and run:

```bash
ansible-playbook site.yml -K --limit <new-host-name>
```
