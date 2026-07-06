# appflow.md — User journeys & screens

**Project:** The Corner Table   **Status:** ✅ COMPLETE (mockups approved by owner 2026-05-03)

## Customer journey (the only public flow)

1. **Landing/booking page** — restaurant name, photo, opening hours, booking form (date picker →
   available time slots → party size → name + phone + email). Unavailable slots are not shown
   (capacity check runs before display, not after submit).
2. **Confirmation screen** — "Table for 4, Friday 7:30pm, under the name Priya." Booking reference
   shown. Email confirmation sent.
3. **Error path** — slot taken between page load and submit → friendly message offering the three
   nearest free slots. No dead ends.

> 📝 Teaching note: the error path is part of the flow, not an afterthought. Every flow in your
> appflow.md needs its unhappy paths drawn in the mockups too — that's where beginners' apps break.

## Owner journey (admin — CROSS-03)

1. **Login** (hosted auth, MFA).
2. **Today view (default screen)** — tonight's bookings in time order: name, party size, phone,
   notes. One-tap call. Live counter: "42 covers booked / 60 capacity."
3. **Any-date view** — same list for any date; calendar shows booking density.
4. **Edit/cancel a booking** — confirmation step states the blast radius in plain language ("This
   cancels Priya's table for 4 and emails her"). Action logged; undo available for 10 minutes.
5. **Block dates/slots** — mark holidays/private events; blocked slots vanish from the public form.
6. **Health strip** — bookings today, emails sent/failed, error count, month's running cost.

> 📝 Teaching note: screens 2–6 exist because of CROSS-03 Rule A — every feature ships with its
> admin visibility. The health strip is the "see everything" principle at toy scale. Note the
> blast-radius wording on cancel: that's CROSS-03's powerful-action rule, visible in a mockup.

## Mockup record

Mockups produced before this doc was finalised (Section 9 Step 2): 7 screens (3 customer, 4 admin),
approved by owner on 2026-05-03. Change during mockup review: owner moved the health strip from a
separate page onto the Today view — cheaper to catch on a picture than after build.
