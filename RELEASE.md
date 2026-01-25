# Release Guide

## Version Numbers

The app uses **semantic versioning**: `MAJOR.MINOR.PATCH` (e.g., `0.1.0`)

| Change Type | Example | When to Use |
|-------------|---------|-------------|
| Patch | 0.1.0 → 0.1.1 | Bug fixes, small tweaks |
| Minor | 0.1.1 → 0.2.0 | New features (backwards compatible) |
| Major | 0.2.0 → 1.0.0 | Production release or breaking changes |

The **build number** (the number in parentheses like `(18)`) auto-increments with each workflow run.

## How to Release

### 1. Update Version (if needed)

Edit `pubspec.yaml`:
```yaml
version: 0.2.0+1  # Change 0.1.0 to your new version
```

### 2. Commit Your Changes

```bash
git add .
git commit -m "Release v0.2.0: Add new events screen"
```

### 3. Create a Git Tag

```bash
git tag v0.2.0
git push origin master
git push origin v0.2.0
```

### 4. Done!

The workflow will automatically:
- Run tests
- Build the APK
- Upload to Firebase App Distribution
- Notify testers

## Development Workflow

| Action | What Happens |
|--------|--------------|
| Push to master | Tests run, APK builds, but NO Firebase deploy |
| Create tag `v*` | Tests run, APK builds, AND deploys to Firebase |

This means you can push as many times as you want during development without spamming testers with new builds.

## Quick Commands

```bash
# See all tags
git tag

# Create and push a release
git tag v0.2.0
git push origin v0.2.0

# Delete a tag (if you made a mistake)
git tag -d v0.2.0
git push origin --delete v0.2.0
```

## Release Notes

Release notes are automatically generated from:
- Version number from `pubspec.yaml`
- Git commit messages since last tag
- Build date and commit hash

To write good release notes, use descriptive commit messages:
```bash
# Good
git commit -m "Add events screen with calendar view"
git commit -m "Fix prayer time calculation for DST"

# Not helpful
git commit -m "update"
git commit -m "fix bug"
```
