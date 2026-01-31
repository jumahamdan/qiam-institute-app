# Audio Licensing

> ⚠️ **Important:** Verify all audio licensing before app distribution.

---

## Status

| Source | Verified | Notes |
|--------|----------|-------|
| EveryAyah.com | ✅ Yes | Free for apps, add attribution |
| Adhan files | ⚠️ Check | Document sources for each file |

---

## Quran Recitation Sources

| Source | Type | Notes |
|--------|------|-------|
| [EveryAyah.com](https://everyayah.com) | Free for apps | ✅ Already used by `quran` package |
| [QuranicAudio.com](https://quranicaudio.com) | Free | Large collection, check terms |
| Islamic archives | Varies | Some Creative Commons |
| Makkah/Madinah official | Requires permission | Contact Saudi authorities |

---

## Adhan Audio Sources

| Source | License | Notes |
|--------|---------|-------|
| Public domain recordings | Free | Some classic recordings |
| Creative Commons | Attribution required | Check each recording |
| Makkah/Madinah muezzins | Requires permission | Most authentic |
| Self-recorded | Full rights | Consider hiring a muezzin |

---

## Current Implementation

```
✅ Quran Recitation: Using EveryAyah.com URLs (via quran package)
   - 10 reciters available
   - Streaming from CDN
   - No local files required

✅ Adhan Audio: Local files
   - makkah.mp3 - Ahmad al Nafees
   - madinah.mp3 - Hafiz Mustafa Özcan
   - mishary.mp3 - Mishary Rashid Alafasy
   - fajr variants
```

---

## Action Required

Add to About/Credits screen:

> "Quran audio recitations provided by EveryAyah.com"

---

[← Back to Plan](../islamic-features-plan.md)
