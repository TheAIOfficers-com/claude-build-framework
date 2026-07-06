# TRD — Technical Requirements Document

**Project:** The Corner Table   **Status:** ✅ COMPLETE (gate passed 2026-05-04)

## Stack

- Front-end: server-rendered pages + a small amount of client script (mobile-first)
- Backend / API: one lightweight API service
- Database: managed Postgres
- Auth: hosted auth for the OWNER'S admin login only (customers don't log in — see PRD §7)
- Hosting: managed platform with preview deploys, staging + production environments
- Email: transactional email provider (booking confirmations)
- Monitoring: platform error tracking + uptime check

> 📝 Teaching note: a real TRD names the actual chosen products (mirroring STACK.md). This example
> stays generic because the framework repo names no vendors — YOUR TRD should be specific, with the
> choice reasoning in decisions.md.

## APIs

- `POST /api/bookings` — create booking (validates capacity; returns confirmation id)
- `GET /api/admin/bookings?date=` — owner's list (auth required)
- `PATCH /api/admin/bookings/:id` — edit/cancel (auth required, logged)
- `POST /api/admin/blocks` — block a date/slot (auth required)
- Versioning: none needed at this scale; breaking changes = new field additions only (Layer 2 rule:
  never remove fields in place).

## Auth approach

- Owner admin: hosted auth, email + strong password + MFA, single role ("owner"). No multi-tenancy.
- Customers: none. A booking is identified by id + phone for edits via the owner.

## Which 13-layer docs apply

ACTIVE for this build: Layers 1–9, 12, 13. Layer 10 (caching/CDN) and Layer 11 (scaling) noted as
gaps accepted at this traffic level (single venue) — recorded in the Gap Report and techdebt.md.
No reference architectures apply (no voice, no AI agent, no helpdesk).

**Framework:** v1.3.0 (pinned 2026-05-04)
