# Contributing to Ninja Fleet

Thank you for your interest in contributing to the Ninja Fleet infrastructure!

## How to Contribute

1. **Bug Reports & Feature Requests**: Use GitHub Issues to report problems or suggest improvements.
2. **Pull Requests**:
   - Fork the repository.
   - Create a descriptive branch (e.g., `feature/new-role` or `fix/typo`).
   - Ensure your changes follow the existing project structure.
   - Run `ansible-lint` to verify code quality.
   - Submit a pull request to the `main` branch.

## Code Standards

- **Idempotency**: All tasks must be idempotent.
- **Modularity**: Keep roles focused on single responsibilities.
- **Portability**: Use variables instead of hardcoded paths or values whenever possible.
- **Security**: Never commit sensitive data. Use example files and documentation for private configurations.

Let's build a better fleet together! 🦅
