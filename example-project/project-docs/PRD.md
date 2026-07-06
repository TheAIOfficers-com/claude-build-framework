# PRD — Product Requirements Document

**Project:** The Corner Table   **Status:** ✅ COMPLETE (gate passed 2026-05-04)

## 1. Objective

Let customers of one small restaurant book a table online in under a minute, and let the owner see
and manage every booking without phone calls or a paper diary.

> 📝 Teaching note: one sentence, specific, measurable-ish ("under a minute"). Not "revolutionise
> dining." If the objective needs a paragraph, the product isn't understood yet.

## 2. Target audience

- **Primary:** customers of this specific restaurant (locals, ages ~25–65, booking from a phone,
  usually same-day or next-day). Job to be done: "reserve a table without calling during my workday."
- **Secondary:** the restaurant owner (non-technical), checking bookings from a phone between
  services. Job: "know who's coming tonight and stop double-bookings."

## 3. Competitors & their features

| Competitor | What they do | Key features | Strengths | Weaknesses / gaps |
|------------|--------------|--------------|-----------|-------------------|
| Phone + paper diary (status quo) | Owner takes calls | None | Zero cost, familiar | Missed calls = lost bookings; double-bookings; no record |
| Big booking platforms | Multi-restaurant marketplaces | Discovery, reviews, reminders | Polished, trusted | Per-booking fees; customer data belongs to the platform; overkill for one venue |
| Form builders (generic) | Embed a form on a site | Simple forms | Cheap, fast | No capacity logic — double-bookings; no admin view |

> 📝 Teaching note: the status quo IS a competitor — usually the main one. Researched rows would be
> marked with source and date; these three were known first-hand by the owner.

## 4. USP

For a single small restaurant: no per-booking fees, the customer data stays with the owner, and
capacity is actually enforced (unlike a plain form). Simpler and cheaper than a marketplace, smarter
than a form. Follows directly from the section 3 gaps.

## 5. Core features

| Feature | Objective (why it exists) | In v1? | Notes |
|---------|---------------------------|--------|-------|
| Booking form (date, time, party size, name, phone) | The product's single core action | ✅ | Mobile-first |
| Capacity check | Prevent double-bookings — the #1 status-quo failure | ✅ | Per-slot table count |
| Booking confirmation (on-screen + email) | Customer trusts the booking happened | ✅ | |
| Owner admin: today's bookings list | Owner's core job-to-be-done | ✅ | CROSS-03 Rule A |
| Owner admin: cancel/edit a booking | Reality: plans change; without this the phone returns | ✅ | Logged, reversible |
| Owner admin: block out dates/slots | Holidays and private events exist | ✅ | |

> 📝 Teaching note: six features, each with a one-line objective that survives challenge. During
> brainstorming, "SMS reminders" and "customer accounts" were proposed and CUT — see section 7 and
> productdebt.md. Cutting is the PRD working as intended.

## 6. Success criteria

- Owner stops using the paper diary within 2 weeks of launch.
- ≥ 60% of bookings arrive online (vs phone) within 2 months.
- Zero double-bookings caused by the system.

## 7. Out of scope (v1)

- SMS reminders (cost + consent complexity; parked in productdebt.md).
- Customer accounts/login (a booking needs a name and phone, not a password).
- Multi-restaurant support (this is one venue; generalising now would triple the schema for zero
  current users).
- Payments/deposits (owner explicitly doesn't want to charge no-shows yet).

> 📝 Teaching note: every out-of-scope line says WHY. That's what stops the same debate recurring
> every month.
