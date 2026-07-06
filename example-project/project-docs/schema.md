# schema.md — Data model

**Project:** The Corner Table   **Status:** ✅ COMPLETE (gate passed 2026-05-04)

## Tables

### bookings
| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| booking_date | date | indexed with slot_time |
| slot_time | time | 30-min slots from opening hours |
| party_size | int | 1–12 (larger = phone the owner) |
| customer_name | text | |
| customer_phone | text | for owner contact; not shown publicly |
| customer_email | text | confirmation email |
| status | enum: confirmed / cancelled / no_show | default confirmed |
| notes | text nullable | allergies, occasions |
| created_at / updated_at | timestamptz | |

### slot_blocks
| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| block_date | date | |
| slot_time | time nullable | null = whole day blocked |
| reason | text | shown only in admin |

### capacity_rules
| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| day_of_week | int 0–6 | |
| slot_time | time | |
| max_covers | int | owner-editable in admin |

### admin_audit_log (append-only)
| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| actor | text | owner account id |
| action | text | e.g. booking_cancelled |
| target_id | uuid | |
| detail | jsonb | before/after |
| at | timestamptz | |

## Integrity rules

- Capacity is enforced in the DATABASE (transactional check on insert), not only in the UI —
  two customers submitting the same last slot must not both succeed. (Layer 3.)
- Personal data (name/phone/email) is the only PII held; retention 12 months post-visit then
  anonymised (CROSS-01). No card data anywhere.
- Cancelling sets `status`, never deletes — the audit log and no-show history depend on it.

> 📝 Teaching note: four tables. The capacity-in-the-database rule is the single most important
> line in this file — beginners' booking apps double-book because only the FORM checked. Schema
> docs earn their keep by stating where rules are ENFORCED, not just what columns exist.
