# Framework rules (reference)

Follow the TheAIOfficers build framework. Read its CLAUDE.md, the ACTIVE layer docs, the cross-cutting
docs (compliance, AI reliability, admin/operability), and any relevant reference architecture.
Do not duplicate the framework here — this file just routes Claude to it.

Key non-negotiables (full detail in the framework):
- Pre-coding gate: the project planning docs must be complete before coding.
- Workflow: SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT.
- Every feature ships with its admin visibility (CROSS-03).
- Never trust the client; security and compliance per Layers 2/4/8 and CROSS-01.
- Acceptance is gated by DEFINITION-OF-DONE.md.
