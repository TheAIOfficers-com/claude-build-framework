# design.md — UI / design language

**Project:** The Corner Table   **Status:** ✅ COMPLETE (gate passed 2026-05-04)

## Design language

- Warm, unfussy, trustworthy — like the restaurant. No dashboard-app aesthetics on the customer side.
- Mobile-first: the booking form must be completable one-handed on a phone.

## Tokens

- **Colors:** cream background `#FAF6F0`; ink text `#22201C`; brand terracotta `#C4572E` (buttons,
  links); success green `#2E7D4F`; error red `#B3261E`. All pairings meet WCAG AA contrast.
- **Type:** one serif for headings (restaurant warmth), one system sans for body/forms. Two fonts
  maximum.
- **Spacing:** 8px grid. Form fields ≥ 48px tall (thumb-friendly).
- **Corners/shadows:** soft (8px radius), single subtle shadow level. No glassmorphism, no gradients.

## Components

Button (primary/secondary/destructive), text input, date picker, time-slot chips (selected /
available / gone), booking card (admin), confirmation banner, blast-radius confirm dialog.

## Accessibility (Layer 1)

Labels on every field, error messages in text not colour alone, focus states visible, date picker
keyboard-operable.

> 📝 Teaching note: short is correct. A design doc for a small product fits on one page — tokens,
> components, accessibility floor. The mockups carry the rest. If your design.md is ten pages,
> it's a mood board, not a spec.
