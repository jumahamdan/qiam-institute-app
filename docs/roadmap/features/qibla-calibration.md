# Feature 7: Qibla Calibration Improvements

> **Status:** ⏳ Planned  
> **Priority:** Medium

---

## Current Issue

Qibla accuracy is slightly off. Current implementation detects when accuracy < 15 but only shows text "Move in figure-8."

---

## Planned Improvements

| Task | Priority | Status |
|------|----------|--------|
| Animated figure-8 calibration guide | High | ⏳ |
| Accuracy percentage display bar | High | ⏳ |
| Calibration tutorial overlay | Medium | ⏳ |
| Visual feedback when calibration improves | Medium | ⏳ |

---

## Proposed Design

```
┌─────────────────────────────────────────────────────────────┐
│                    QIBLA DIRECTION                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                      🧭                                      │
│                   [Compass]                                 │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  ⚠️ Calibration Needed                                      │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                      │   │
│  │              [Figure-8 Animation]                    │   │
│  │                                                      │   │
│  │         Move your phone in a figure-8 motion        │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Accuracy: [████████░░░░░░░░░░░░] 40%                      │
│                                                             │
│  Keep moving until accuracy reaches 80%+                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Notes

- Use Lottie animation for figure-8 guide
- Real-time accuracy percentage from magnetometer
- Auto-dismiss calibration overlay when accuracy > 80%
- Remember calibration state in session

---

[← Back to Plan](../islamic-features-plan.md)
