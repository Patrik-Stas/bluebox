# bluebox

Isolated Docker sandboxes for running Claude Code with `--dangerously-skip-permissions`. Each container runs [mdboard](https://pypi.org/project/mdboard/) on startup for project management via a web UI.

## Install

```bash
brew tap Patrik-Stas/bluebox
brew install bluebox
```

Or clone the repo and use `./bluebox` directly.

## Quick start

```bash
# Build the images (once)
bluebox build

# Create a sandbox with mdboard exposed on port 9001
bluebox create my-project --mdboard 9001

# Open the task board
open http://localhost:9001
```

## Project directories

When you create a sandbox, a directory named after the project is created in your current working directory and bind-mounted into the container. If the directory already exists (even with files in it), it gets mounted as-is.

```bash
cd ~/projects
bluebox create my-app --mdboard 9001

# ~/projects/my-app/ now syncs with /home/dev/my-app/ inside the container
```

A shared directory at `~/.bluebox/shared/<name>/` is also mounted at `/home/dev/shared/` for file exchange between host and container.

## Working in a sandbox

```bash
# Open a shell (run from multiple terminals)
bluebox enter my-project

# Start working
claude --dangerously-skip-permissions
```

## Language-specific images

By default, sandboxes use a Node.js base image. Use `--rust` for Rust projects:

```bash
bluebox create my-engine --rust --mdboard 9002
```

The Rust image includes the Rust toolchain, clippy, rustfmt, cargo-watch, and cargo-edit, plus Node.js for Claude Code.

## Port forwarding

Use `--mdboard` for the task board and `-p` for additional ports:

```bash
# mdboard only
bluebox create my-project --mdboard 9001

# mdboard + an app server
bluebox create my-project --mdboard 9001 -p 3000:3000

# multiple sandboxes
bluebox create project-a --mdboard 9001
bluebox create project-b --mdboard 9002 --rust
```

## Managing sandboxes

```bash
bluebox list                # Show all sandboxes and mdboard URLs
bluebox stop my-project     # Pause (data preserved)
bluebox start my-project    # Resume
bluebox destroy my-project  # Remove container (project dir preserved)
bluebox nuke my-project     # Remove container + shared data (permanent)
```

## What's in the images

**Default** (`bluebox`): Node 20, git, curl, wget, python3, uv, build-essential, vim, jq, sudo. Non-root user `dev` with sudo access. Claude Code and mdboard.

**Rust** (`bluebox-rust`): Everything above plus the Rust toolchain, clippy, rustfmt, cargo-watch, cargo-edit, pkg-config, and libssl-dev.

## Notes

- Project files live on your host filesystem — they persist across stop/start/destroy/recreate.
- Installed packages and auth state live in the container layer — lost on `destroy`.
- Set `ANTHROPIC_API_KEY` on your host before `create`, or log in interactively inside the container.
