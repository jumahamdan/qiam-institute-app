# Live Stream Integration Plan

> **Status:** Planning  
> **Created:** January 28, 2026  
> **Priority:** Medium  
> **Depends On:** FCM Setup (in progress)

---

## Overview

Automatically detect when Qiam Institute goes live on YouTube and notify users, with the option to watch directly in the app.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    FULLY AUTOMATIC FLOW                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Qiam starts live stream on YouTube                      │
│                                                             │
│  2. YouTube sends webhook (PubSubHubbub) to Cloud Function  │
│                                                             │
│  3. Cloud Function receives "channel went live" event       │
│                                                             │
│  4. Cloud Function calls Firebase Cloud Messaging API       │
│                                                             │
│  5. All app users receive push notification:                │
│     "🔴 Qiam is LIVE! Tap to watch"                         │
│                                                             │
│  6. User taps notification → App opens to live stream       │
│                                                             │
│  BACKUP: Manual notification via Firebase Console           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## When Will Qiam Go Live?

| Event | Frequency | Predictable? |
|-------|-----------|--------------|
| Friday Khutbah | Weekly | ✅ Yes |
| Ramadan Taraweeh | Daily during Ramadan | ✅ Yes |
| Special Events | Occasional | ⚠️ Announced ahead |
| Random Live | Rare | ❌ No |

**Key insight:** 90% of live streams are scheduled and predictable.

---

## Phase 1: FCM Foundation (Required First)

Before live stream integration, FCM must be working.

### Checklist
- [ ] Firebase project configured
- [ ] `google-services.json` in place
- [ ] FCM package added to app
- [ ] Notification permission requested
- [ ] Handle incoming notifications
- [ ] Test manual notification from Firebase Console

---

## Phase 2: App-Side Live Stream Handling

### Constants to Add

```dart
// lib/config/constants.dart

// YouTube Live Stream
static const String youtubeChannelId = 'UC_________'; // Get from @qiaminstitute
static const String liveStreamUrl = 'https://www.youtube.com/channel/UC_________/live';

// FCM Topics
static const String fcmTopicLive = 'live_notifications';
static const String fcmTopicAll = 'all_users';
```

### Notification Handler

When app receives notification with `type: "live"`:

```dart
// Handle incoming FCM message
void handleLiveNotification(RemoteMessage message) {
  final data = message.data;
  
  if (data['type'] == 'live') {
    final videoId = data['videoId'];
    final title = data['title'] ?? 'Qiam is LIVE!';
    
    // If app is open, navigate to live stream
    navigatorKey.currentState?.pushNamed('/live', arguments: videoId);
    
    // If app was closed, deep link handles it
  }
}
```

### Notification Payload Structure

```json
{
  "notification": {
    "title": "🔴 Qiam is LIVE!",
    "body": "Friday Khutbah is starting. Tap to watch."
  },
  "data": {
    "type": "live",
    "videoId": "abc123xyz",
    "title": "Friday Khutbah",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  },
  "topic": "live_notifications"
}
```

---

## Phase 3: Live Stream Screen

### Screen Design

```
┌─────────────────────────────────────────────────────────────┐
│                    LIVE STREAM SCREEN                       │
├─────────────────────────────────────────────────────────────┤
│  ←                                    🔴 LIVE    [⛶]       │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                      │   │
│  │                                                      │   │
│  │            [YouTube Live Player]                     │   │
│  │                                                      │   │
│  │                                                      │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Friday Khutbah                                             │
│  Started 15 minutes ago • 234 watching                      │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  [🔔 Get notified for future streams]                       │
│                                                             │
│  [📺 Open in YouTube]        [↗️ Share]                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Phase 4: Explore Card - Live View

### When LIVE

```
┌─────────────────────┐
│  🔴 LIVE NOW        │  ← Red badge, pulsing animation
│                     │
│  [Stream Thumbnail] │
│                     │
│  Watch Live         │
│  234 watching       │
└─────────────────────┘
```

### When NOT LIVE

```
┌─────────────────────┐
│  📺 Live Streams    │
│                     │
│  [Mosque Image]     │
│                     │
│  "Check back during │
│   events for live   │
│   broadcasts"       │
└─────────────────────┘
```

**Tapping when not live:**
- Option A: Show message "No live stream right now"
- Option B: Open past recordings on YouTube
- Option C: Show schedule of upcoming streams

---

## Phase 5: Cloud Function (Full Automation)

### Prerequisites
- Firebase Blaze plan (pay-as-you-go, but free tier covers this)
- YouTube Data API key (optional, for auto-detection)

### Option A: YouTube PubSubHubbub Webhook

YouTube supports PubSubHubbub for channel updates.

```javascript
// Firebase Cloud Function

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.youtubeWebhook = functions.https.onRequest(async (req, res) => {
  // Verify it's from YouTube
  // Parse the Atom feed
  // Check if it's a live stream starting
  
  const isLive = checkIfLiveStream(req.body);
  
  if (isLive) {
    const videoId = extractVideoId(req.body);
    const title = extractTitle(req.body);
    
    // Send FCM to all users subscribed to 'live_notifications'
    await admin.messaging().sendToTopic('live_notifications', {
      notification: {
        title: '🔴 Qiam is LIVE!',
        body: `${title} is starting. Tap to watch.`,
      },
      data: {
        type: 'live',
        videoId: videoId,
        title: title,
      },
    });
  }
  
  res.status(200).send('OK');
});
```

### Option B: Zapier/Make Automation (Easier)

No code needed:

1. **Trigger:** YouTube → New Video by Channel
2. **Filter:** Only if live stream
3. **Action:** Webhook → POST to Firebase FCM API

**Zapier setup:**
- Free tier: 100 tasks/month (plenty for live streams)
- Setup time: ~1 hour
- No server maintenance

---

## Phase 6: Manual Backup

If automation fails, send notification manually:

### Firebase Console Steps

1. Go to Firebase Console → Cloud Messaging
2. Click "New Campaign" → "Notifications"
3. Fill in:
   - **Title:** `🔴 Qiam is LIVE!`
   - **Body:** `Friday Khutbah is starting. Tap to watch.`
4. Click "Additional options" → "Custom data"
5. Add:
   - `type` = `live`
   - `videoId` = `[paste video ID]`
6. Target: Topic = `live_notifications`
7. Send

**Time required:** ~30 seconds

---

## Implementation Order

| Phase | Task | Depends On | Effort |
|-------|------|------------|--------|
| 1 | FCM setup in app | - | In progress |
| 2 | Handle live notification type | Phase 1 | 2-3 hours |
| 3 | Create live stream screen | Phase 2 | 3-4 hours |
| 4 | Add "Live" card to Explore | Phase 3 | 1-2 hours |
| 5 | Cloud Function automation | Phase 1 | 4-6 hours |
| 6 | Manual backup process | Phase 1 | Document only |

---

## Files to Create

```
lib/
  screens/
    live/
      live_stream_screen.dart
  services/
    live/
      live_stream_service.dart     # Check live status, handle notifications
  widgets/
    live/
      live_badge.dart              # Pulsing "LIVE" indicator
      live_explore_card.dart       # Card for explore page

# Firebase (separate repo or folder)
functions/
  index.js                         # Cloud Function for webhook
```

---

## Constants Needed

```dart
// Add to lib/config/constants.dart

// YouTube Channel
static const String youtubeChannelId = 'UC_________'; // Extract from @qiaminstitute

// Live Stream URLs
static const String liveStreamUrl = 'https://www.youtube.com/channel/$youtubeChannelId/live';
static const String liveStreamEmbed = 'https://www.youtube.com/embed/live_stream?channel=$youtubeChannelId';

// FCM Topics
static const String topicLiveNotifications = 'live_notifications';
```

---

## How to Get YouTube Channel ID

1. Go to `https://www.youtube.com/@qiaminstitute`
2. Right-click → View Page Source
3. Search for `channelId` or look for string starting with `UC`
4. Copy the ID (format: `UCxxxxxxxxxxxxxxxxxxxxx`)

**Or use online tool:** `https://commentpicker.com/youtube-channel-id.php`

---

## Notes

- Live stream detection is push-based, not polling (battery efficient)
- App doesn't check YouTube API constantly (zero API calls when not live)
- Manual backup ensures reliability even if automation fails
- User can opt-out of live notifications in settings
- Consider showing "Upcoming" card if stream is scheduled but not started
