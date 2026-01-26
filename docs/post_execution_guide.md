# Post-Execution: Cleanup & Verification Guide

Congratulations on your first live run! Now that the "heavy lifting" is done, here is how to verify the new order and tidy up the last bits of the old world.

## Linux Repository Fixes 🛠️

If you encountered errors related to Steam GPG keys on `ninja-server`, Ansible has now fixed these by ensuring the correct keys are in `/usr/share/keyrings/steam.gpg`.

- **Verification**: Run `sudo apt-get update` on `ninja-server`. It should now complete without "NO_PUBKEY" warnings.

## 1. Refresh Your Terminal 🐚

Because Ansible modified your `~/.zshrc`, your current shell session is a mix of old and new.

- **Action**: Close your terminal entirely and open a new one.
- **Verification**: Run `which rbenv` and `which nvm`. They should now point to paths managed by the new Ansible blocks.

## 2. Legacy File Cleanup (Option B Follow-up) 🧹

Ansible has already stopped your `.zshrc` from _using_ the legacy dev file, but the file still exists on your Mac.

- **Action**: Once you are 100% sure your shell environment is working, you can archive or delete the legacy file:
  ```bash
  mv ~/.zshrc.dev ~/.zshrc.dev.bak  # Archive it just in case
  # OR
  rm ~/.zshrc.dev                  # Delete it forever
  ```

## 3. Server Side Tidy-up 🐳

Since we removed `sonarr` and `romm`, their Docker images might still be taking up space on `ninja-server`.

- **Action**: Log in to the server and run:
  ```bash
  docker system prune -a --volumes
  ```
  _(Caution: This removes all unused data, so only run it if you aren't planning to restore those services immediately.)_

## 4. VPN Connectivity Test 📡

Let's make sure the "Surgical VPN" setup on your Mac is solid.

- **Command**: `sudo wg-quick up wg0`
- **Verification**: Run `wg show`. It should show a connection to `vpn.ghepting.com`.
- **Check**: Try `ping 10.13.13.1` (the internal VPN gateway).

## 5. Caddy Health Check 🌐

Ensure your new Caddyfile is being served correctly.

- **Command**: `curl -I https://dns.ghepting.com`
- **Expectation**: A clean `200 OK` or `Redirect`.

## 6. Verification of Tagging 🏷️

Test that your new "Surgical Control" is working.

- **Command**: `ansible-playbook site.yml -K -t shell --check`
- **Expectation**: This should only run the ZSH/Python/Ruby/Node tasks and skip everything else (like Docker/VPN install).

---

**Your fleet is now unified, clean, and professional. You're ready to scale!** 🦅💻
