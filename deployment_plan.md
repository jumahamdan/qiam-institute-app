## Plan: Deploy Flutter App to Google Play Store

This plan covers the requirements to publish the Qiam Institute app on Google Play Store. The app is currently in development phase with most foundation in place.

**Last Updated:** 2026-01-27

---

### Steps

1. **Generate production keystore and configure signing** - DONE
   - Created `android/app/upload-keystore.jks` (RSA 2048-bit, 10000 days validity)
   - Created `android/key.properties` (gitignored) for local builds
   - Updated `android/app/build.gradle.kts` with release signing configuration
   - Added `android/app/proguard-rules.pro` for code minification
   - Keystore backup: Stored in GitHub Secrets + local copy for Dashlane

2. **Create and host a privacy policy** - PENDING
   - Required because the app collects location data
   - Host at `qiaminstitute.org/privacy` or similar public URL

3. **Update CI workflow to build AAB** - DONE
   - CI now builds both APK (for Firebase distribution) and AAB (for Play Store)
   - Keystore is securely decoded from GitHub Secrets during CI
   - Added GitHub Secrets: `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`

4. **Bump version to `1.0.0`** in [pubspec.yaml](pubspec.yaml) for production release - PENDING

5. **Prepare Play Store listing assets** - PENDING
   - 512x512 app icon
   - 1024x500 feature graphic
   - Minimum 2 phone screenshots
   - Short description (80 chars)
   - Full description (4000 chars)

6. **Complete Google Play Console setup** - PENDING
   - Create developer account ($25)
   - Upload AAB to internal testing track
   - Complete Data Safety section
   - Content rating questionnaire

---

### GitHub Secrets Configured

| Secret | Description | Status |
|--------|-------------|--------|
| `KEYSTORE_BASE64` | Base64-encoded upload keystore | Configured |
| `KEYSTORE_PASSWORD` | Keystore and key password | Configured |
| `KEY_ALIAS` | Key alias (`upload`) | Configured |
| `GOOGLE_SERVICES_JSON` | Firebase config (base64) | Configured |
| `FIREBASE_APP_ID` | Firebase App ID | Configured |
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account | Configured |

---

### CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/build-and-distribute.yml`) now:

1. **Runs tests** on all pushes and PRs
2. **Builds release** APK and AAB with production signing (skipped on PRs)
3. **Distributes to Firebase**:
   - `develop` branch -> notifies `qiam-developers` group
   - `master`/`main` branch -> notifies `qiam-testers` group

---

### Remaining Tasks

| Task | Priority | Notes |
|------|----------|-------|
| Create privacy policy | High | Required for Play Store |
| Bump to v1.0.0 | High | When ready for production |
| Play Store assets | High | Screenshots, descriptions |
| Google Play Console setup | High | Account + app listing |
| iOS build & TestFlight | Medium | Future expansion |

---

### Keystore Backup Checklist

- [x] Stored in GitHub Secrets (`KEYSTORE_BASE64`)
- [ ] Save to Dashlane:
  - Password: (from key.properties)
  - Key Alias: `upload`
  - Keep a copy of `android/app/upload-keystore.jks`

**Important:** The upload keystore is irreplaceable. If lost, you cannot update the app on Play Store.
