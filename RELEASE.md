# Release Process and PyPI Publishing Guide

This document describes the process for releasing a new version of tinyaes to PyPI, along with best practices.

## Prerequisites

Before you start the release process, ensure you have:

1. **PyPI Account**: Create an account at https://pypi.org if you don't have one
2. **PyPI API Token**: Generate an API token from your PyPI account settings (recommended over password)
3. **Repository Access**: Maintainer access to the GitHub repository
4. **Required Tools**: 
   - `twine` for uploading to PyPI
   - `build` for building distributions
   - `just` for running automation tasks

## Release Workflow

### 1. Prepare the Release

1. **Update Version Number**
   - Edit `setup.py` and update the `version` field
   - Follow [Semantic Versioning](https://semver.org/):
     - **PATCH** (e.g., 1.1.1 → 1.1.2): Bug fixes, minor updates
     - **MINOR** (e.g., 1.1.x → 1.2.0): New features, backward compatible
     - **MAJOR** (e.g., 1.x.x → 2.0.0): Breaking changes

2. **Update Release Notes**
   - Edit the `README.md` file
   - Add a new entry at the top of the "Release notes" section
   - Include the version number, date, and list of changes
   - Format: `- **X.Y.Z** (Month Day, Year)`

3. **Test Locally**
   ```bash
   # Run tests to ensure everything works
   just test
   
   # Build the distribution
   just dist
   ```

### 2. Create a GitHub Release

1. **Commit and Push Changes**
   ```bash
   git add setup.py README.md
   git commit -m "Bump version to X.Y.Z"
   git push origin main
   ```

2. **Create and Push a Git Tag**
   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```

3. **Create GitHub Release**
   - Go to the repository's GitHub page
   - Click on "Releases" → "Create a new release"
   - Select the tag you just created (vX.Y.Z)
   - Add release notes (copy from README.md)
   - Publish the release

### 3. Automated PyPI Upload

The repository uses GitHub Actions for automated building and publishing:

- **Trigger**: Pushing a tag starting with `v` (e.g., `v1.1.2`)
- **Workflow**: `.github/workflows/build_and_upload.yml`
- **Process**:
  1. Builds wheels for Linux, Windows, and macOS
  2. Builds source distribution (sdist)
  3. Automatically uploads to PyPI

**Note**: The workflow requires `PYPI_USERNAME` and `PYPI_PASSWORD` secrets to be configured in the repository settings.

### 4. Manual PyPI Upload (Alternative)

If you need to upload manually or test on TestPyPI:

1. **Build Distributions**
   ```bash
   just dist
   ```

2. **Test on TestPyPI (Recommended for major changes)**
   ```bash
   # Upload to TestPyPI
   twine upload --repository testpypi dist/*X.Y.Z*
   
   # Install from TestPyPI to test
   pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ tinyaes
   ```

3. **Upload to PyPI**
   ```bash
   # Using API token (recommended)
   twine upload dist/*X.Y.Z*
   
   # Or with username/password
   twine upload -u __token__ -p pypi-YOUR_API_TOKEN dist/*X.Y.Z*
   ```

## Best Practices

### Version Management

1. **Follow Semantic Versioning**: Makes it clear what type of changes are included
2. **Use Release Candidates**: For major changes, consider releasing an RC first (e.g., 1.2.0rc1)
3. **Keep Version Consistent**: Ensure version in `setup.py` matches the git tag

### Testing Before Release

1. **Run Full Test Suite**: Always run `just test` before releasing
2. **Test on Multiple Python Versions**: The CI already tests on Python 3.8-3.14
3. **Test Installation**: Try installing from the built wheel locally
4. **Use TestPyPI**: For major releases, test on TestPyPI first

### Documentation

1. **Update Release Notes**: Always document what changed in the release
2. **Keep CHANGELOG**: The README.md serves as the changelog - keep it updated
3. **Update README**: If there are API changes or new features, update examples

### Security

1. **Use API Tokens**: Never commit passwords; use PyPI API tokens
2. **Store Secrets Securely**: Use GitHub Secrets for CI/CD credentials
3. **Review Dependencies**: Check for security vulnerabilities before releasing
4. **Sign Releases**: Consider signing git tags with GPG

### CI/CD Configuration

The repository's GitHub Actions workflow handles:

- **Multiple Python Versions**: 3.8, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14
- **Multiple Platforms**: Linux (ubuntu-22.04), Windows (windows-2022), macOS (macos-14)
- **Automated Building**: Creates wheels and source distributions
- **Automated Publishing**: Uploads to PyPI on version tags

### Common Issues and Solutions

**Issue**: Build fails on a specific platform
- **Solution**: Check the GitHub Actions logs, ensure all dependencies are available

**Issue**: Upload to PyPI fails with "File already exists"
- **Solution**: You cannot overwrite an existing version; bump the version number

**Issue**: Wheels don't work on some systems
- **Solution**: Check CIBW_BUILD settings in `.github/workflows/build_and_upload.yml`

**Issue**: Tests pass locally but fail in CI
- **Solution**: Ensure all dependencies are listed in requirements-dev.txt

## Useful Links

- [Python Packaging User Guide](https://packaging.python.org/)
- [Semantic Versioning](https://semver.org/)
- [PyPI Help](https://pypi.org/help/)
- [TestPyPI](https://test.pypi.org/)
- [Twine Documentation](https://twine.readthedocs.io/)
- [cibuildwheel Documentation](https://cibuildwheel.readthedocs.io/)

## Quick Reference

```bash
# Complete release process (manual)
just test                        # Run tests
git add setup.py README.md       # Stage version changes
git commit -m "Bump version to X.Y.Z"
git push origin main             # Push changes
git tag -a vX.Y.Z -m "Release version X.Y.Z"
git push origin vX.Y.Z          # Push tag (triggers CI/CD)

# Manual build and upload (if needed)
just dist                        # Build distributions
twine upload dist/*X.Y.Z*       # Upload to PyPI
```
