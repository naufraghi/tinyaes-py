# AGENTS.md

## Cursor Cloud specific instructions

### Overview

`tinyaes` is a Cython wrapper around the [tiny-AES-c](https://github.com/kokke/tiny-AES-c) C library, providing AES-128 encryption/decryption in CTR and CBC modes. It is a single Python package (not a monorepo) with no external services.

### Prerequisites

- **Python 3.10+** with dev headers (`python3-dev` system package)
- **C compiler** (gcc) — pre-installed on most Linux environments
- The `tiny-AES-c` git submodule must be initialized: `git submodule update --init`

### Key commands

| Action | Command |
|--------|---------|
| Install dev deps | `pip install -r requirements-dev.txt` |
| Build (editable) | `pip install -e .` |
| Run tests | `python3 -m pytest . -v` |
| Quick smoke test | See `justfile` recipe `_test` |

### Non-obvious caveats

- The system command is `python3`, not `python` (no `python` symlink on Ubuntu 24.04).
- `python3-dev` must be installed for the C extension to compile; without it, `pip install -e .` fails with `Python.h: No such file or directory`.
- After changing `.pyx` source, you must re-run `pip install -e .` to recompile the Cython extension — there is no hot reload.
- The `justfile` creates a virtualenv per hostname; in cloud agent environments, use `pip install` directly instead of `just test` to avoid unnecessary venv layering.
