# Features 9 & 10: Feedback & Volunteer Forms

> **Status:** ✅ Complete  
> **Priority:** High

---

## Overview

Forms that collect user feedback and volunteer applications, using Microsoft Forms with responses automatically saved to SharePoint Lists.

| Form | Location | URL |
|------|----------|-----|
| App Feedback | Settings | `https://forms.cloud.microsoft/r/Vy0Expj9Fe` |
| Volunteer Application | Explore | `https://forms.cloud.microsoft/r/Rvqxz5eHNL` |

---

## Architecture (Updated)

Using **Microsoft Forms** (Free!) instead of Power Automate Premium.

```
┌─────────────────┐                    ┌──────────────────┐
│  App            │   Opens URL/       │  Microsoft Form  │
│  (Button tap)   │   WebView          │  (Hosted by MS)  │
└─────────────────┘  ───────────────>  └────────┬─────────┘
                                                │
                                                │ Auto-saves (FREE!)
                                                ▼
                                       ┌──────────────────┐
                                       │  SharePoint List │
                                       │  (Qiam Tenant)   │
                                       └──────────────────┘
```

### Why Microsoft Forms?
- ✅ **FREE** - No Power Automate Premium license needed
- ✅ **Auto-saves to SharePoint Lists** - Responses automatically stored and queryable
- ✅ **Email notifications** - Can be configured in form settings
- ✅ **Easy to manage** - Edit form anytime via forms.office.com
- ✅ **Team access** - Anyone with Qiam account can view responses in SharePoint

---

## Form URLs

### App Feedback Form
```
https://forms.cloud.microsoft/r/Vy0Expj9Fe
```

### Volunteer Application Form
```
https://forms.cloud.microsoft/r/Rvqxz5eHNL
```

---

## App Integration Options

### Option 1: Open in External Browser (Simplest)

```dart
// Feedback button tap
launchUrl(
  Uri.parse('https://forms.cloud.microsoft/r/Vy0Expj9Fe'),
  mode: LaunchMode.externalApplication,
);

// Volunteer button tap
launchUrl(
  Uri.parse('https://forms.cloud.microsoft/r/Rvqxz5eHNL'),
  mode: LaunchMode.externalApplication,
);
```

### Option 2: Open in WebView (Better UX)

```dart
// Navigate to a WebView screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WebViewScreen(
      url: 'https://forms.cloud.microsoft/r/Vy0Expj9Fe',
      title: 'Feedback',
    ),
  ),
);
```

---

## Constants Update

Add to `lib/config/constants.dart`:

```dart
// Form URLs (Microsoft Forms)
static const String feedbackFormUrl = 'https://forms.cloud.microsoft/r/Vy0Expj9Fe';
static const String volunteerFormUrl = 'https://forms.cloud.microsoft/r/Rvqxz5eHNL';
```

---

## Settings Menu Update

Add Feedback to Settings screen:

```
Settings
├── Prayer Times Settings
├── Adhan Settings
├── Notifications
├── Appearance (Theme)
├── ─────────────────────
├── 💬 Feedback & Suggestions  ← Opens feedbackFormUrl
├── ℹ️ About
├── 📄 Privacy Policy
└── (other items...)
```

---

## Viewing Responses

### For Qiam Team:
1. Go to [forms.office.com](https://forms.office.com)
2. Sign in with Qiam account
3. Click on the form
4. Click **Responses** tab to view summary
5. Click **Open in Excel** or view directly in SharePoint List

### Data Location:
Responses are automatically saved to a SharePoint List in the Qiam tenant, providing:
- Direct list access for team members
- Export to Excel when needed
- Integration with Power Automate for advanced workflows
- List views and filtering capabilities

---

## Implementation Tasks

| Task | Priority | Status |
|------|----------|--------|
| Add form URLs to constants.dart | High | ✅ Complete |
| Add Feedback button to Settings screen | High | ✅ Complete |
| Update Volunteer card in Explore to use form URL | High | ✅ Complete |
| Test forms open correctly on Android | High | ✅ Complete |
| Test forms open correctly on iOS | High | ⏳ Pending |
| Configure email notifications in MS Forms (optional) | Low | ⏳ Pending |

---

## Claude Code Prompt

```
You are a senior Flutter developer working on the Qiam Institute Islamic app.

Create a new branch called `feature/feedback-volunteer-forms` from `develop` branch.

## Task: Add Feedback and Volunteer form integration

### Step 1: Update constants.dart

Add these URLs to `lib/config/constants.dart`:

```dart
// Form URLs (Microsoft Forms)
static const String feedbackFormUrl = 'https://forms.cloud.microsoft/r/Vy0Expj9Fe';
static const String volunteerFormUrl = 'https://forms.cloud.microsoft/r/Rvqxz5eHNL';
```

### Step 2: Add Feedback to Settings Screen

In `lib/screens/settings/settings_screen.dart`:
- Add a "Feedback & Suggestions" list tile
- Icon: Icons.feedback or Icons.chat_bubble_outline
- On tap: Open feedbackFormUrl using launchUrl with LaunchMode.externalApplication

### Step 3: Update Volunteer Card in Explore

In the Explore screen, find the Volunteer card and update it to:
- On tap: Open volunteerFormUrl using launchUrl with LaunchMode.externalApplication

### Step 4: Update Documentation

Update `docs/roadmap/islamic-features-plan.md`:
- Change Feature 9 (Feedback Form) status from ⏳ Planned to ✅ Complete
- Change Feature 10 (Volunteer Form) status from ⏳ Planned to ✅ Complete
- Update dashboard counts accordingly

Please proceed with the implementation.
```

---

[← Back to Plan](../islamic-features-plan.md)
