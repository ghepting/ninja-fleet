# Safety & Rollout Guide: Production-Ready Testing

Since your fleet consists of live machines, we should follow a multi-layered safety strategy to ensure that our new project structure and roles don't disrupt your production needs.

## Phase 1: The "Dry Run" (Check & Diff Mode)

Before making any changes, use Ansible's built-in simulation tools. This will show exactly what _would_ happen without actually changing a single byte on the target.

```bash
# Run against the entire fleet in simulation mode
# Use -K to prompt for your sudo password
ansible-playbook site.yml --check --diff -K
```

- **`--check`**: Tells Ansible to simulate the run.
- **`--diff`**: Shows the line-by-line differences in configuration files (especially useful for templates like your `.env` or SSL certs).
- **`-K` (or `--ask-become-pass`)**: Prompts you for your sudo password so Ansible can simulate actions that require `become: true`.

## Phase 2: The "Canary" Host (Limit)

Instead of running against all hosts, pick one specific machine (a "canary") and run the full playbook against just that one.

```bash
# Target a specific host by its name in hosts.ini
ansible-playbook site.yml --limit <hostname>
```

You can also target entire groups (like `workstation`) or multiple specific hosts (comma-separated).

## Phase 3: Targeted Testing (Tags)

If you only want to test a specific part of the new hierarchy (like the common utilities), use tags.

```bash
# Run only tasks tagged with 'common'
ansible-playbook site.yml --tags common --check --diff
```

## Phase 4: Molecule (The First Line of Defense)

Whenever you make a change to the `common` role, run Molecule locally first.

```bash
cd roles/common
molecule test
```

This tests the logic in a clean Debian 12 container, which caught the Docker and Flatpak bugs earlier today!

## Summary of Safe Commands

| Goal                        | Command                                        |
| :-------------------------- | :--------------------------------------------- |
| **Complete Simulation**     | `ansible-playbook site.yml --check --diff`     |
| **Test one host only**      | `ansible-playbook site.yml --limit <hostname>` |
| **Verify inventory logic**  | `ansible-inventory --list`                     |
| **Check for syntax errors** | `ansible-playbook site.yml --syntax-check`     |
