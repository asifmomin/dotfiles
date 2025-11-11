# Colima Docker Socket Configuration

## Issue

When using Colima with Supabase CLI (and potentially other Docker-based tools), explicitly setting `DOCKER_HOST` to the Colima XDG socket path can cause mount errors:

```bash
failed to start docker container: Error response from daemon: error while creating mount source path '/Users/asif/.config/colima/default/docker.sock': mkdir /Users/asif/.config/colima/default/docker.sock: operation not supported
```

## Root Cause

- Colima stores its Docker socket at `~/.config/colima/default/docker.sock` (XDG-compliant path)
- Setting `export DOCKER_HOST="unix://$HOME/.config/colima/default/docker.sock"` makes this explicit
- Some tools (like Supabase CLI) try to mount the `DOCKER_HOST` path as a volume, which fails because:
  - The socket file already exists and cannot be created as a directory
  - Tools expect the standard `/var/run/docker.sock` path for volume mounts

## Solution

**Don't set `DOCKER_HOST` explicitly.** Colima automatically creates a system-wide symlink that works with all Docker tools.

### What Colima Does Automatically

When Colima starts, it creates:
```bash
/var/run/docker.sock -> /Users/asif/.config/colima/default/docker.sock
```

This symlink allows all Docker tools to use the standard path while Colima maintains its XDG-compliant storage.

### Configuration Change

In `packages/shell/.config/zsh/.zshrc`, the `DOCKER_HOST` export has been commented out:

```bash
# Docker configuration (Colima)
# DOCKER_HOST not needed - Colima creates symlink at /var/run/docker.sock
# export DOCKER_HOST="unix://$HOME/.config/colima/default/docker.sock"
```

### Verification

```bash
# Check DOCKER_HOST is unset
echo $DOCKER_HOST
# (should be empty)

# Verify symlink exists
ls -la /var/run/docker.sock
# lrwxr-xr-x  1 root  wheel  51 Nov 10 22:37 /var/run/docker.sock -> /Users/asif/.config/colima/default/docker.sock

# Test Docker works
docker ps

# Test Supabase works
supabase start
```

## Why This Works

1. **Standard Behavior**: Docker tools default to `unix:///var/run/docker.sock` when `DOCKER_HOST` is unset
2. **Colima's Symlink**: The symlink redirects to the actual socket location
3. **Volume Mounts**: Tools that mount the Docker socket get the standard path, avoiding conflicts
4. **XDG Compliance**: Colima still stores its data in XDG-compliant locations

## Affected Tools

This fix resolves issues with:
- ✅ Supabase CLI
- ✅ Docker Compose with volume mounts to Docker socket
- ✅ Tools that need to access Docker daemon from within containers

## Alternative Solutions

If you encounter a tool that specifically needs `DOCKER_HOST` set, you can:

### Option 1: Per-Project Override with direnv

Create `.envrc` in the project directory:
```bash
export DOCKER_HOST="unix://$HOME/.config/colima/default/docker.sock"
```

### Option 2: Temporary Override

```bash
DOCKER_HOST="unix://$HOME/.config/colima/default/docker.sock" some-command
```

### Option 3: Create Additional Symlink

If a tool requires a specific path:
```bash
sudo ln -s ~/.config/colima/default/docker.sock /path/to/expected/location
```

## Troubleshooting

### Symlink Missing or Broken

If `/var/run/docker.sock` doesn't exist or points to wrong location:

```bash
# Restart Colima to recreate symlink
colima stop
colima start

# Verify symlink
ls -la /var/run/docker.sock
```

### Switching Between Colima and Docker Desktop

If you switch between Colima and Docker Desktop:

**For Colima:**
```bash
# Ensure DOCKER_HOST is unset in shell config
# Colima manages the symlink automatically
```

**For Docker Desktop:**
```bash
# Docker Desktop creates its own symlink at /var/run/docker.sock
# No configuration needed
```

### Permission Issues

If you get permission errors:
```bash
# Check Colima status
colima status

# Restart if needed
colima stop
colima start

# Verify socket permissions
ls -la ~/.config/colima/default/docker.sock
# Should show: srw------- 1 asif staff ...
```

## Technical Details

### What Colima Creates

On startup, Colima:
1. Creates VM with Docker runtime
2. Forwards Docker socket from VM to `~/.config/colima/default/docker.sock`
3. Creates system symlink: `/var/run/docker.sock` → `~/.config/colima/default/docker.sock`
4. Sets appropriate permissions (user-only access to socket)

### Why Supabase Failed

Supabase CLI internally uses Docker Compose with configurations like:
```yaml
volumes:
  - ${DOCKER_HOST}:/var/run/docker.sock
```

When `DOCKER_HOST=unix:///Users/asif/.config/colima/default/docker.sock`, Docker tries to:
1. Create mount point inside container
2. Fails because the socket file already exists on host
3. Cannot create a directory with same name as existing socket

With `DOCKER_HOST` unset:
1. Docker uses default `/var/run/docker.sock`
2. Symlink is followed transparently
3. Mount succeeds

## Related Documentation

- [Colima GitHub Repository](https://github.com/abiosoft/colima)
- [Docker Socket Configuration](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-socket-option)
- [Supabase Local Development](https://supabase.com/docs/guides/cli/local-development)

## Date Fixed

November 10, 2025
