# YouTube Video Improvements Plan

> **Status:** Planning  
> **Created:** January 28, 2026  
> **Priority:** High  

---

## Current Issues

| Issue | Impact |
|-------|--------|
| Video causes lag when scrolling | Poor UX, janky performance |
| Video doesn't start muted | Unexpected audio, bad first impression |
| No fullscreen option | Limited viewing experience |
| No controls after video ends | User stuck, can't replay or explore |
| Heavy load on page init | Slow home screen rendering |

---

## Solutions

### 1. Thumbnail-First Approach (Fix Lag)

**Problem:** Loading YouTube player on page load causes scroll lag.

**Solution:** Show static thumbnail by default, only load player when user taps play.

```
┌─────────────────────────────────────────────────────────────┐
│                    DEFAULT STATE                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                      │   │
│  │            [Video Thumbnail Image]                   │   │
│  │                                                      │   │
│  │                    ▶️                                │   │
│  │               (Play Button)                          │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  User taps play → Thumbnail fades out → Player loads       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Implementation:**

```dart
// State variable
bool _isPlayerVisible = false;

// Widget
_isPlayerVisible
  ? YoutubePlayer(controller: _controller)
  : GestureDetector(
      onTap: () => setState(() => _isPlayerVisible = true),
      child: Stack(
        children: [
          Image.network(AppConstants.introVideoThumbnail),
          Center(child: PlayButtonOverlay()),
        ],
      ),
    );
```

---

### 2. Start Muted by Default

**Current:** Video may autoplay with sound.

**Solution:** Always initialize player with `mute: true`.

```dart
_youtubeController = YoutubePlayerController(
  initialVideoId: videoId,
  flags: YoutubePlayerFlags(
    autoPlay: false,        // Don't autoplay
    mute: true,             // Start muted
    showLiveFullscreenButton: true,
  ),
);
```

**UI:** Show clear unmute button overlay.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│         [Video Playing]                                     │
│                                                             │
│                                           🔇 ← Muted icon   │
│                                                             │
│   User taps 🔇 → Changes to 🔊 and unmutes                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

### 3. Add Fullscreen Button

**Solution:** Add fullscreen toggle that rotates to landscape and hides system UI.

```dart
void _enterFullscreen() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

void _exitFullscreen() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
```

**UI Controls:**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│         [Video Playing]                                     │
│                                                             │
│   🔇         advancement advancement advancement advancement advancement �advancement advancement advancement   ⛶    │
│  mute       advancement advancement advancement  bar             fullscreen    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

### 4. Video End Behavior

**Current:** Nothing happens when video ends.

**Solution:** Show replay button and "More Videos" option.

```
┌─────────────────────────────────────────────────────────────┐
│                    VIDEO ENDED STATE                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                      │   │
│  │            [Video Thumbnail / Last Frame]            │   │
│  │                                                      │   │
│  │         🔄 Replay          📺 More Videos           │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│   "More Videos" → Opens Qiam YouTube channel or shows      │
│   a list of recommended videos                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Options for "More Videos":**

| Option | Implementation |
|--------|----------------|
| Open YouTube channel | `launchUrl('https://youtube.com/@qiaminstitute')` |
| Show in-app list | Display 2-3 hardcoded video thumbnails |
| Use YouTube API | Fetch latest videos from channel (requires API key) |

---

### 5. Consider Alternative YouTube Package

**Current package:** `youtube_player_flutter` (check pubspec.yaml)

**Recommended:** `youtube_player_iframe`

| Package | Performance | Features | Platform Support |
|---------|-------------|----------|------------------|
| `youtube_player_flutter` | Medium | Good | Android, iOS |
| `youtube_player_iframe` | Better | Full YouTube controls | All platforms |
| `pod_player` | Good | Lightweight | Android, iOS |

**If switching to `youtube_player_iframe`:**

```yaml
dependencies:
  youtube_player_iframe: ^5.x.x
```

---

## Implementation Checklist

### Phase 1: Quick Wins
- [ ] Start video muted by default
- [ ] Add thumbnail-first approach (lazy load player)
- [ ] Add replay button on video end

### Phase 2: Enhanced Controls
- [ ] Add fullscreen button
- [ ] Add mute/unmute toggle with clear icon
- [ ] Add "More Videos" option on end

### Phase 3: Optimization (if needed)
- [ ] Evaluate switching to `youtube_player_iframe`
- [ ] Add Picture-in-Picture support (Android 8+)
- [ ] Add background audio support

---

## Files to Modify

```
lib/
  screens/
    home/
      home_screen.dart              # Main video widget
  widgets/
    video/
      video_thumbnail_player.dart   # New: Thumbnail-first component
      video_controls.dart           # New: Custom controls overlay
```

---

## Dependencies

```yaml
# Current (verify in pubspec.yaml)
youtube_player_flutter: ^x.x.x

# May need to add
just_audio: ^0.9.x              # For custom audio control (optional)
```

---

## Notes

- Test on low-end devices to verify performance improvement
- Thumbnail URL already exists: `AppConstants.introVideoThumbnail`
- Fullscreen should respect device orientation lock settings
- Consider accessibility: closed captions support
