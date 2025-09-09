# Direnv Configuration

Directory-based environment management with custom layouts and functions.

## Features

- **Custom layout functions** for common project types
- **Runtime version management** integration with mise
- **Docker development** environment setup
- **Cloud provider** configuration (AWS, Kubernetes)
- **Secrets management** integration with SOPS
- **Database setup** for development environments

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ direnv
```

## Structure

```
direnv/
└── .config/
    └── direnv/
        └── direnvrc       # Custom functions and layouts
```

## Usage

### Basic Environment Files

Create `.envrc` files in your project directories:

```bash
# .envrc - Basic environment variables
export NODE_ENV=development
export DEBUG=myapp:*
export PORT=3000
```

### Layout Functions

#### Node.js Projects
```bash
# .envrc - Node.js with specific version
layout_nodejs 18.17.0

# Or use LTS
layout_nodejs lts
```

#### Python Projects
```bash
# .envrc - Python with virtual environment
layout_python 3.11

# Custom virtual environment name
layout_python 3.11 venv
```

#### Go Projects
```bash
# .envrc - Go with project-specific GOPATH
layout_go 1.21

# Or latest version
layout_go latest
```

#### Rust Projects
```bash
# .envrc - Rust with specific toolchain
layout_rust stable

# Or nightly toolchain
layout_rust nightly
```

#### Docker Development
```bash
# .envrc - Docker development environment
layout_docker

# Custom compose file
layout_docker docker-compose.dev.yml
```

### Cloud Integration

#### AWS Profiles
```bash
# .envrc - AWS profile switching
use_aws personal
use_aws work-production
```

#### Kubernetes Contexts
```bash
# .envrc - Kubernetes context switching
use_kubectl development
use_kubectl production
```

### Environment Loading

#### Load .env Files
```bash
# .envrc - Load from .env file
dotenv

# Custom .env file
dotenv .env.development
```

#### Load Encrypted Secrets
```bash
# .envrc - Load SOPS-encrypted secrets
load_secrets secrets/development.sops.yaml
```

### Development Utilities

#### Local Binaries
```bash
# .envrc - Add local bin directories to PATH
use_local_bin
```

#### Development Databases
```bash
# .envrc - Configure development database URLs
use_dev_database postgres myapp
use_dev_database mysql myapp
use_dev_database redis
```

## Example Project Configurations

### Full-Stack Web Application
```bash
# .envrc
layout_nodejs 18
use_local_bin
dotenv .env.development
use_dev_database postgres
use_aws development

export API_URL=http://localhost:3001
export FRONTEND_URL=http://localhost:3000
```

### Python Data Science Project
```bash
# .envrc
layout_python 3.11 .venv
use_local_bin
dotenv

export JUPYTER_PORT=8888
export PYTHONPATH="$PWD/src:$PYTHONPATH"
```

### Go Microservice
```bash
# .envrc
layout_go 1.21
use_local_bin
use_dev_database postgres
load_secrets secrets/development.sops.yaml

export CGO_ENABLED=0
export GOOS=linux
```

### Rust CLI Tool
```bash
# .envrc
layout_rust stable
use_local_bin

export RUST_LOG=debug
export RUST_BACKTRACE=1
```

### Docker-based Development
```bash
# .envrc
layout_docker docker-compose.dev.yml
use_local_bin
dotenv .env.docker

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
```

### Multi-Cloud DevOps Project
```bash
# .envrc
use_aws staging
use_kubectl staging-cluster
use_local_bin
load_secrets secrets/staging.sops.yaml

export TERRAFORM_WORKSPACE=staging
export HELM_NAMESPACE=myapp-staging
```

## Integration with Development Tools

### Shell Integration
Works automatically with zsh configuration:
- Environment loaded when entering directories
- Environment unloaded when leaving directories
- Starship prompt shows direnv status

### Editor Integration
Configure your editor to respect direnv:

#### Neovim (via LazyVim)
```lua
-- In LazyVim, direnv is automatically supported
-- Environment variables are available in terminal and LSP
```

#### VS Code
```json
{
  "direnv.restart.automatic": true,
  "direnv.status.showStatus": true
}
```

### Runtime Management
Integrates with mise (recommended) or other version managers:
- Automatic version switching per project
- Consistent environments across team members
- Support for multiple language runtimes

## Security Considerations

### Trusted Directories
Direnv requires explicit approval for new `.envrc` files:

```bash
# Allow .envrc in current directory
direnv allow

# Check current status
direnv status
```

### Secrets Management
- Use `load_secrets` for encrypted secrets only
- Never commit `.envrc` files with secrets to version control
- Use SOPS for team secret sharing

### Environment Isolation
- Each project gets isolated environment
- No pollution of global shell environment
- Clean environment when leaving project directory

## Troubleshooting

### Direnv Not Loading
Check if direnv is properly configured:
```bash
# Verify direnv hook in shell
echo $DIRENV_HOOK

# Check direnv status
direnv status

# Reload current directory
direnv reload
```

### Permission Issues
```bash
# Allow current directory
direnv allow .

# Allow all .envrc files (not recommended)
direnv allow
```

### Environment Not Found
```bash
# Check .envrc syntax
direnv check

# Debug environment loading
direnv export json | jq
```

### Runtime Version Issues
```bash
# Verify mise installation
mise --version

# Check available versions
mise list-all node
mise list-all python
mise list-all go
```

## Best Practices

### Project Organization
1. **One .envrc per project root**
2. **Environment-specific .env files** (.env.development, .env.production)
3. **Secrets in SOPS files** (secrets/development.sops.yaml)
4. **Documentation of required variables** in README

### Team Collaboration
1. **Commit .envrc files** to version control
2. **Use .env.example** for documenting required variables
3. **Use SOPS for shared secrets**
4. **Document direnv setup** in project README

### Security
1. **Never commit secrets** in .envrc files
2. **Use direnv allow** carefully
3. **Regular audit** of environment variables
4. **Separate secrets by environment**

## Common Patterns

### Monorepo Support
```bash
# .envrc in repo root
use_local_bin
dotenv .env.shared

# .envrc in service subdirectory
source_up  # Load parent .envrc
layout_nodejs 18
dotenv .env.service
```

### CI/CD Integration
```bash
# .envrc for CI environment detection
if [[ -n "$CI" ]]; then
    export NODE_ENV=test
    export DATABASE_URL="postgresql://test:test@localhost:5432/test"
else
    dotenv .env.development
    use_dev_database postgres
fi
```

## Resources

- [Direnv Documentation](https://direnv.net/)
- [Mise Documentation](https://mise.jdx.dev/)
- [SOPS Integration Guide](../secrets/README.md)