# Contributing

Improvements are welcome. This framework governs how AI builders behave on real projects, so
changes are reviewed strictly — the bar is "does this make builds safer, clearer, or cheaper to
verify," not "is this interesting."

## How to propose a change

1. **Open an issue first for anything substantial.** Describe the problem the change solves. For
   small fixes (typos, broken links, clarity), a direct pull request is fine.
2. **One topic per pull request.** A PR that fixes a typo AND rewrites a section will be closed
   and asked to split. Small, single-purpose changes get reviewed fast; bundles don't get
   reviewed at all.
3. **Say what and why in the PR description, in plain language.** The owner of this repo is
   non-technical by design — if the description needs programming knowledge to understand, it
   isn't ready.
4. **Update `CHANGELOG.md` in the same PR** (add an entry under a new version heading per
   `GOVERNANCE.md` Section 4, including the why). PRs without a changelog entry are asked to add
   one before review.
5. **Match the house style.** Rule documents speak in two voices — 🟦 direct instructions for the
   builder AI, 🟩 plain-language explanation for the owner. Keep both when editing rules.

## What gets accepted

- Clarifications that remove ambiguity from an existing rule.
- New checks, gates, evidence requirements, or plain-language explanations.
- Corrections of factual or internal inconsistencies.
- Better wording for non-technical readers.

## What gets rejected

- Anything that weakens, softens, or adds exceptions to a gate, check, log, or approval — the
  framework only gets harder to misuse, never easier (`GOVERNANCE.md` Section 5, the one-way rule).
- Instructions for an AI to fetch, install, or connect to specific external tools or services.
  Sections 15–17 of `CLAUDE.md` deliberately name no products: the rule is to check what exists at
  the time and advise the owner. Keep it that way.
- Large rewrites bundled with small fixes.
- Changes to the governance rules themselves (`GOVERNANCE.md` Sections 3 and 5) — those change
  only by the owner's own hand.

## How review works

Every PR is audited by an independent AI against the current framework (does it strengthen or
weaken any rule? does it hide behaviour the description doesn't mention?), substantial ones by
two different models independently, and the owner makes the final merge decision personally.
Details in `GOVERNANCE.md` Section 5. Expect questions in plain language; answering them well is
most of getting merged.
