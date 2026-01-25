# Qiam Institute — Mobile App MVP (Occam’s Razor)

Date started: 2026-01-24

## Goal (1 sentence)
Ship a very basic, low-cost mobile app for Qiam Institute that shows Events + Updates + Prayer Times + Qibla + Notifications, and can later be released on iOS/Android.

## MVP Scope (keep it tiny)
### Must-have (v0)
- Home screen: next prayer + quick links (Events / Updates / Qibla)
- Events list + event detail
- Updates/announcements list + detail
- Prayer times: today + 7-day view (local calculation, works offline)
- Qibla direction (basic; uses location + device orientation)
- Notifications (phase 2 of MVP): start with “broadcast announcements”

### Nice-to-have (not in v0)
- Donation button, media/podcast, login, bookmarks, Q&A, community directory
- Full admin panel, multi-language, advanced theming, offline event cache

## Lowest-cost Tech Stack (recommended)
- App: Flutter (single codebase for iOS + Android)
- Data source for Events/Updates (start cheapest):
  - Option A (cheapest/fastest): read from Qiam website (WordPress) via REST/RSS; no new backend.
  - Option B (still cheap): Firebase Firestore as a lightweight CMS (manual entry via Firebase Console).
- Push notifications:
  - Firebase Cloud Messaging (FCM)
  - Use Firebase Functions only if needed (avoid at first)

Why: Flutter is already present in this workspace, free, and gets you to iOS/Android with one app.

## Distribution & Testing (lowest cost path)
### Android
- Internal testing: share APK/AAB directly (free) or Play Console internal track (requires $25 Google Play account)

Recommended for pilot (<10 testers): Firebase App Distribution for Android.

### iOS
- Real device testing requires Apple dev + provisioning
- Internal testing: TestFlight (requires $99/year Apple Developer Program)

### Pre-store testing
- Firebase App Distribution (good, relatively low friction)
- BrowserStack is usually paid; consider it only if you need wide device coverage (or a free trial to reproduce a specific device bug).

### “Hosting” for a mobile pilot (clarification)
- For a pilot, you typically don’t “host the app” — you distribute builds (e.g., Firebase App Distribution).
- If you need a hosted config/content file later, keep it free/simple (e.g., GitHub Pages or Firebase Hosting) or pull Events/Updates directly from the existing website.

## Non-obvious constraints / things people miss
- iOS builds require macOS (or a CI provider that builds on macOS). If you only have Windows, plan for:
  - Borrowing a Mac, using a friend’s Mac, or using a CI provider with macOS runners.
- Push notifications require extra iOS setup (APNs keys/certs + entitlements).
- Qibla/compass accuracy varies; you must handle “no sensor / poor calibration” gracefully.
- Location permissions: keep them minimal and explain why.
- App Store / Play Store: you’ll need basic privacy disclosures (even for a simple app).

## Reference links (source context)
- Website: https://qiaminstitute.org/
- Events page: https://qiaminstitute.org/events/
- Facebook: https://www.facebook.com/p/Qiam-Institute-61573449077244/

Notes from website (for copy/positioning): Qiam Institute describes itself as “a home of learning, belonging, healing, and growth… rooted in faith… open to all who seek knowledge, connection, and purpose.”

---

# Claude CLI Prompt (paste this into Claude)

You can run Claude CLI in an interactive mode, or paste as a single prompt. The goal is for Claude to output:
1) a minimal architecture decision, 2) a step-by-step plan, 3) a backlog, 4) a documentation skeleton we can keep in this folder.

PROMPT START

You are a senior product+mobile engineer. Use Occam’s Razor: pick the simplest approach that works.

Context:
- We are building a very basic MVP mobile app for Qiam Institute (https://qiaminstitute.org/).
- The app should show: Events, Updates/Announcements, Notifications, Prayer Times, and Qibla.
- We want the absolute lowest cost and lowest complexity.
- We want eventual deployment to iOS and Android.
- Pilot plan: start with Android-only distribution to <10 testers via Firebase App Distribution; avoid paid tools unless necessary.
- BrowserStack is optional: use only if we need extra device coverage or a trial to reproduce a device-specific issue.

Constraints:
- Start with a read-only app (no user accounts).
- Avoid custom backend if possible.
- Prefer Flutter.
- Events/Updates content should be maintainable without building an admin dashboard.

Deliverables (in Markdown):
A) “Project Charter” (1 page): problem, users, MVP, out-of-scope, success metrics.
B) “Architecture Decision (ADR-0001)”: choose data source strategy:
   - Option 1: consume Qiam website content via WordPress REST API / RSS.
   - Option 2: Firebase Firestore as a simple CMS.
   Compare cost, reliability, maintenance, and implementation complexity. Pick one.
C) “Milestone Plan” with 4–6 milestones, each with acceptance criteria.
D) “Backlog” as a prioritized checklist (≤30 items) with effort estimates (S/M/L).
E) “Risks & Mitigations” (top 10), especially iOS build/signing on Windows, notifications setup, location/compass accuracy.
F) “Repo Structure Proposal” for a new folder/repo.
G) “CI/CD minimal plan”:
   - Phase 1: manual builds
   - Phase 2: GitHub Actions for Android builds
   - Phase 3: iOS build options (macOS runner limitations, CodeMagic, or using a Mac)
H) “Firebase App Distribution workflow”: steps + where secrets go; keep it minimal.
I) “MVP UI wireframe (text-only)”: 4–6 screens with navigation.

Be explicit about the simplest prayer times + qibla approach:
- Use local calculation libraries + location
- No login
- Offline support for prayer times

Also include a short “Questions to ask Qiam” section (≤12 questions).

PROMPT END

---

# Execution Checklist (what we do next)

## 0) Confirm one decision
- [ ] Decide content source for Events/Updates (Website/RSS vs Firestore)

## 1) Create the app shell (after decision)
- [ ] `flutter create qiam_institute_app`
- [ ] Add basic navigation + placeholder screens

## 2) Implement the core features (minimal)
- [ ] Events list/detail (from chosen source)
- [ ] Updates list/detail
- [ ] Prayer times (local calc + location)
- [ ] Qibla (direction + graceful fallback)

## 3) Add notifications (only after content works)
- [ ] Firebase project setup
- [ ] Android FCM wiring
- [ ] iOS APNs + FCM wiring
- [ ] Simple topic-based broadcast (e.g., `announcements`)

## 4) Distribution
- [ ] Firebase App Distribution: Android first
- [ ] iOS TestFlight when ready

## 5) Release readiness (later)
- [ ] App icon/splash
- [ ] Privacy policy + store metadata
- [ ] Crash reporting (optional: Firebase Crashlytics)

---

# Decision Log
- 2026-01-24: Created planning folder and initial MVP plan.
