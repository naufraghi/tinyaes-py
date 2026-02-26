# Release Process

Version is derived automatically from git tags via
[`setuptools-scm`](https://github.com/pypa/setuptools-scm).
There is no version string in source code — the git tag **is** the version.

## Version format

Tags must follow PEP 440 with a `v` prefix:

| Tag | PyPI version | Type |
|-----|-------------|------|
| `v1.3.0rc1` | `1.3.0rc1` | Pre-release (release candidate) |
| `v1.3.0rc2` | `1.3.0rc2` | Pre-release (release candidate) |
| `v1.3.0` | `1.3.0` | Final release |

Between tags, `setuptools-scm` generates dev versions like `1.3.0.dev5+gabcdef`
(these are never uploaded to PyPI).

## Workflow

### 1. Develop

Work on `master` (or feature branches merged to `master`).
Update the release notes in `README.md`.

### 2. Pre-release

When ready to test a release candidate:

```bash
git tag v1.3.0rc1
git push origin v1.3.0rc1
```

CI builds wheels for all platforms and uploads `tinyaes==1.3.0rc1` to PyPI.

Install and test:

```bash
pip install --pre tinyaes
# or pin explicitly:
pip install tinyaes==1.3.0rc1
```

Pre-releases are **not** installed by default — users must opt in with `--pre`
or pin the exact version.

### 3. Iterate (if needed)

If issues are found, fix them on `master`, then tag the next candidate:

```bash
git tag v1.3.0rc2
git push origin v1.3.0rc2
```

### 4. Final release

When the release candidate is validated, tag the final on the same (or later) commit:

```bash
git tag v1.3.0
git push origin v1.3.0
```

CI uploads `tinyaes==1.3.0` to PyPI. **No code changes needed** to promote
an rc to final — it's just a new tag.

## CI details

Pushing any `v*` tag triggers the `upload_pypi` job in `.github/workflows/ci.yml`:

- Builds wheels via `cibuildwheel` on Linux, macOS, and Windows
- Builds source distribution
- Uploads everything to PyPI

Repository secrets `PYPI_USERNAME` and `PYPI_PASSWORD` must be configured.

## Manual upload (if needed)

```bash
just dist
twine upload dist/*
```

## Checking the current version

```bash
python -m setuptools_scm
```
