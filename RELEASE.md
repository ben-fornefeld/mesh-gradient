# Release Guide

This document describes the automated release process for `mesh_gradient`.

## Prerequisites

1. **GitHub Actions Setup** (one-time setup)
   - Go to [pub.dev/packages/mesh_gradient/admin](https://pub.dev/packages/mesh_gradient/admin)
   - Navigate to "Automated publishing"
   - Follow instructions to link your GitHub repository
   - This sets up OIDC authentication (no tokens needed!)

2. **Install Melos** (optional, script will install if needed)
   ```bash
   dart pub global activate melos
   ```

## Release Process

### Automated Release (Recommended)

Run the release script:

```bash
bash release.sh
```

The script will:
1. Check for uncommitted changes
2. Prompt for version bump type (patch/minor/major/custom)
3. Ask for changelog description
4. Update `pubspec.yaml` and `CHANGELOG.md`
5. Commit changes and create a git tag
6. Show next steps

Then push to GitHub:

```bash
git push && git push --tags
```

GitHub Actions will automatically publish to pub.dev when the tag is pushed.

### Manual Release

If you prefer manual control:

1. **Update version** in `pubspec.yaml`
   ```yaml
   version: 1.3.9
   ```

2. **Update CHANGELOG.md**
   ```markdown
   ## 1.3.9 (2025-10-05)
   
   Description of changes
   ```

3. **Commit and tag**
   ```bash
   git add pubspec.yaml CHANGELOG.md
   git commit -m "chore(release): 1.3.9"
   git tag v1.3.9
   git push && git push --tags
   ```

4. **Monitor GitHub Actions**
   - Go to your repository's Actions tab
   - Watch the "Publish to pub.dev" workflow
   - Verify publication at pub.dev

## Version Bump Guidelines

Follow [semantic versioning](https://semver.org/):

- **Patch** (1.3.8 → 1.3.9): Bug fixes, minor improvements
- **Minor** (1.3.8 → 1.4.0): New features, backward-compatible
- **Major** (1.3.8 → 2.0.0): Breaking changes

## Troubleshooting

### Release script fails

If the script fails, you can rollback:
```bash
git reset --hard HEAD~1
git tag -d vX.X.X  # delete the tag
```

### GitHub Actions fails

1. Check the Actions tab for error logs
2. Verify pub.dev automated publishing is configured
3. Ensure the tag format is correct (`vX.X.X`)
4. Check that `pubspec.yaml` version matches the tag

### Dry-run before publishing

Test the package before releasing:
```bash
dart pub publish --dry-run
```

## CI/CD Workflows

### Test Workflow
- Runs on every push and PR
- Analyzes code, checks formatting, runs tests
- Must pass before merging

### Publish Workflow  
- Triggers on version tags (`v*.*.*`)
- Publishes to pub.dev automatically
- Uses OIDC authentication (secure, no tokens)

## Best Practices

1. **Always test before releasing**
   ```bash
   flutter test
   flutter analyze
   ```

2. **Write meaningful changelog entries**
   - Describe what changed and why
   - Mention breaking changes clearly
   - Reference issue numbers if applicable

3. **Keep commits clean**
   - One version bump per commit
   - Use conventional commit format
   - Don't mix feature changes with version bumps

4. **Review before pushing tags**
   - Tags trigger automatic publishing
   - Once published, versions are immutable
   - Review with `git show` before pushing

## Quick Reference

```bash
# automated release
bash release.sh

# manual version bump
melos version patch --yes
melos version minor --yes  
melos version major --yes

# publish locally (not recommended)
dart pub publish --dry-run  # test first
dart pub publish            # requires manual auth
```

