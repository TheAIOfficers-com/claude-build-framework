# schema.md — Database Schema

**Project:** _TBD_   **Status:** ⬜ INCOMPLETE

> Changing schema later is expensive — get this right up front. Follow Layer 3 rules
> (constraints in DB, audit columns created_at/updated_at, UUIDs for URL-exposed IDs, soft deletes).

## Tables
For each table: name, columns (type, nullable, default), and purpose.

## Relationships
Foreign keys and cardinality (one-to-many, many-to-many).

## Indexes
Columns to index (filter/sort/join + all FKs) per Layer 3.

## Sensitive data
Which columns are PII/regulated? Retention/encryption notes (Layer 3 + CROSS-01).
