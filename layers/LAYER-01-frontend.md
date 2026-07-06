# LAYER 01 — Front-End Foundations

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** The interface is usable, accessible, and behaves predictably for every
user on every supported device.

---

## 🟩 FOR THE FOUNDER — what this layer is

This is everything the user actually sees and touches: screens, buttons, forms, layout, text.
A demo "looks fine on my laptop." A product works on a cheap phone, on slow internet, for someone
using a screen reader, and doesn't break when a user does something unexpected. This layer is the
difference between "it loads" and "people can rely on it."

---

## 🟦 FOR CLAUDE CODE — rules to enforce

The aim is met only when ALL of the following hold:

1. **Responsive** — usable from ~320px mobile width up to desktop. No horizontal scroll, no
   cut-off content.
2. **Accessible (baseline)** — semantic HTML, alt text on images, labels on inputs, keyboard
   navigable, sufficient color contrast (WCAG AA).
3. **Loading & empty & error states** — every screen that fetches data has a visible loading
   state, a sensible empty state, and a graceful error state. No blank screens, no infinite spinners.
4. **Input validation** — all user input is validated in the UI with clear, human-readable
   messages (validation is ALSO enforced server-side — see Layer 2).
5. **No secrets in the front end** — API keys, tokens, and credentials never live in client code.
6. **Predictable navigation** — consistent layout, no dead links, back button works.
7. **Performance baseline** — no obviously oversized assets; images sized appropriately; avoid
   blocking the first render unnecessarily.

🟦 If any of the above is skipped for speed, do NOT silently proceed — list it in the Gap Report.

### Mobile deep linking — applies ONLY when the build includes a mobile app

🟩 **FOR THE FOUNDER** — if you have a mobile app, a shared link to your content should open
*inside the app*, not bounce the user to the browser and a login wall (where confused users leave).
This is fixed with small configuration files, not code. Without it, every shared link is a dead end.

🟦 **FOR CLAUDE CODE** — when a mobile app is in scope, the aim also requires:
8. **Apple Universal Links** — host an `apple-app-site-association` JSON file at the domain root;
   it tells iOS which URL paths open the app directly (no redirect). Apple verifies it at install.
9. **Android App Links** — host a Digital Asset Links JSON file at the domain root and add intent
   filters to the Android manifest; tells Android which URLs open the app. (Expo: `expo-linking`.)
   The same URLs work on both platforms.
10. **Graceful fallback** — if the app is not installed, the link opens the website showing the
    same content plus a smart banner prompting app install. (Expo Router handles this in config.)
    One URL: installed → opens in app; not installed → opens website with install prompt.

If a mobile app exists and deep linking is absent, flag it — shared links are silently failing.

---


### Audited gaps (from research) — additional rules
11. **Core Web Vitals** at the 75th percentile of real-user data: LCP < 2.5s (loading), INP < 200ms
    (responsiveness — replaced FID in 2024), CLS < 0.1 (visual stability). Affects conversions and
    search ranking.
12. **Bundle-size budgets** — set and enforce; defer/lazy-load non-critical and third-party scripts
    (top cause of poor INP); reserve space for images/embeds to avoid layout shift.
13. **SEO basics** — server/pre-rendered critical content, proper meta tags, semantic HTML.
14. **State-management discipline** — single source of truth, predictable updates.
15. **Front-end is an XSS surface** — encode all rendered user data, rely on CSP (Layer 8), never put
    secrets in client code.
16. **i18n-ready from the start** — externalized strings, locale-aware formatting.
17. **Form UX** — inline validation messages, clear loading/empty/error states, accessible labels.

## Checklist (verify before calling this layer done)

- [ ] Works at 320px and up, no horizontal scroll
- [ ] Keyboard navigable + labels + alt text + AA contrast
- [ ] Loading / empty / error state on every data-driven screen
- [ ] Client-side input validation with clear messages
- [ ] Zero secrets in client code
- [ ] Consistent nav, no dead links
- [ ] Assets reasonably sized
- [ ] (Mobile app only) Apple Universal Links configured (apple-app-site-association)
- [ ] (Mobile app only) Android App Links configured (Digital Asset Links + intent filters)
- [ ] (Mobile app only) Fallback to website + install banner when app not installed

---

## Open questions for the founder (fill in per project)

- Which devices/browsers must we officially support?
- Is there a brand/design system to follow, or design freely?
- Any accessibility commitment beyond WCAG AA?
