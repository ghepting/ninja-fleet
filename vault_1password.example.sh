#!/bin/bash

# Examples:
#  - Using names:
# op read "op://Private/Ansible_Vault_Password/password" | tr -d '\n'
#  - Using UUIDs:
# op read "op://a7wkxnqp3ybz5m9vrtlcdfj2gh/k4e8yunbwt6xza2ovhrjqp5mis/password" | tr -d '\n'

# Replace <vault_name_or_uuid>, <vault_item_name_or_uuid>, and <vault_field_name> with your actual 1Password vault, item, and secret names or UUIDs
op read "op://<vault_name_or_uuid>/<vault_item_name_or_uuid>/<vault_field_name>" | tr -d '\n'
