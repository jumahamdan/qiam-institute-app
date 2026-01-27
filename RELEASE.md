# Release Guide

## Version Numbers

The app uses **semantic versioning**: `MAJOR.MINOR.PATCH` (e.g., `0.1.0`)

| Change Type | Example | When to Use |
|-------------|---------|-------------|
| Patch | 0.1.0 -> 0.1.1 | Bug fixes, small tweaks |
| Minor | 0.1.1 -> 0.2.0 | New features (backwards compatible) |
| Major | 0.2.0 -> 1.0.0 | Production release or breaking changes |

The **build number** auto-increments with each GitHub Actions workflow run.

---

## CI/CD Pipeline

### What Happens Automatically

| Action | Tests | APK | AAB | Firebase Distribution |
|--------|-------|-----|-----|----------------------|
| Push to `feature/**` | Yes | Yes | Yes | No |
| Push to `develop` | Yes | Yes | Yes | Yes (qiam-developers) |
| Push to `master` | Yes | Yes | Yes | Yes (qiam-testers) |
| Pull Request | Yes | Yes | Yes | No |

### Build Artifacts

Every successful build produces:
- **APK** — `qiam-institute-apk` artifact (for direct installation / Firebase)
- **AAB** — `qiam-institute-aab` artifact (for Play Store upload)

Download artifacts from the GitHub Actions run page.

---

## How to Release

### Development Release (to developers)

1. Merge your feature branch to `develop`
2. The pipeline automatically:
   - Runs tests
   - Builds signed APK and AAB
   - Distributes APK to `qiam-developers` group on Firebase

### Production Release (to testers)

1. Merge `develop` to `master`
2. The pipeline automatically:
   - Runs tests
   - Builds signed APK and AAB
   - Distributes APK to `qiam-testers` group on Firebase

### Play Store Release

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1  # Change to your new version
   ```

2. Commit and push to `master`:
   ```bash
   git add pubspec.yaml
   git commit -m "Release v1.0.0: Initial production release"
   git push origin master
   ```

3. Wait for the build to complete

4. Download the AAB artifact from GitHub Actions

5. Upload to Google Play Console:
   - Go to Release > Production > Create new release
   - Upload the `.aab` file
   - Add release notes
   - Submit for review

---

## Quick Commands

```bash
# Check current version
grep 'version:' pubspec.yaml

# See recent builds
gh run list --limit 5

# Download latest APK artifact
gh run download --name qiam-institute-apk

# Download latest AAB artifact
gh run download --name qiam-institute-aab

# View build logs
gh run view <run-id> --log
```

---

## Release Notes

Release notes are automatically generated from:
- Version number from `pubspec.yaml`
- Git commit messages (last 10 non-merge commits)
- Build date and commit hash

Write descriptive commit messages for better release notes:

```bash
# Good
git commit -m "Add events screen with calendar view"
git commit -m "Fix prayer time calculation for DST"

# Not helpful
git commit -m "update"
git commit -m "fix bug"
```

---

## GitHub Secrets Required

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Upload keystore encoded in base64 |
| `KEYSTORE_PASSWORD` | Password for keystore and key |
| `KEY_ALIAS` | Key alias (e.g., `upload`) |
| `GOOGLE_SERVICES_JSON` | Firebase config file (base64) |
| `FIREBASE_APP_ID` | Firebase App ID for distribution |
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account JSON |

---

## Troubleshooting

### Build fails at signing step

Check that all keystore secrets are configured correctly:
```bash
gh secret list
```

Should show: `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`

### Firebase distribution fails

Ensure `FIREBASE_APP_ID` and `FIREBASE_SERVICE_ACCOUNT` are configured.

### Tests fail

Run tests locally first:
```bash
flutter test
```

---

## Local Signing Setup

For local release builds, create `android/key.properties`:

```properties
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=upload
storeFile=upload-keystore.jks
```

Then build:
```bash
flutter build apk --release
flutter build appbundle --release
```
