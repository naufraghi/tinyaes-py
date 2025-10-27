# Release Process

This document describes how to release a new version of tinyaes to PyPI.

## Release Steps

1. **Update version in `setup.py`**
   - PATCH version (e.g., 1.1.1 → 1.1.2): Bug fixes, minor updates
   - MINOR version (e.g., 1.1.x → 1.2.0): New features, backward compatible
   - MAJOR version (e.g., 1.x.x → 2.0.0): Breaking changes

2. **Update release notes in `README.md`**
   - Add new entry at the top of "Release notes" section
   - Format: `- **X.Y.Z** (Month Day, Year)`
   - List the changes included in the release

3. **Test locally**
   ```bash
   just test
   ```

4. **Commit and push**
   ```bash
   git add setup.py README.md
   git commit -m "Bump version to X.Y.Z"
   git push origin main
   ```

5. **Create and push git tag**
   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```

Pushing the tag automatically triggers the GitHub Actions workflow (`.github/workflows/build_and_upload.yml`) which:
- Builds wheels for Linux, Windows, and macOS (Python 3.8-3.14)
- Builds source distribution
- Uploads everything to PyPI

## Manual Upload (if needed)

If automatic upload fails or you need to test on TestPyPI first:

```bash
# Build distributions
just dist

# Optional: Test on TestPyPI
twine upload --repository testpypi dist/*X.Y.Z*

# Upload to PyPI
twine upload dist/*X.Y.Z*
```

**Note**: Repository secrets `PYPI_USERNAME` and `PYPI_PASSWORD` must be configured for automated uploads.
