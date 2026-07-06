# LAYER 08 — Security & Row-Level Security

**Status:** ✅ ACTIVE (enforced by Claude Code) — all sections A–F ACTIVE: secrets, RLS, encryption, testing, isolation (when in scope), incident runbook
**Aim (non-negotiable):** Data is protected in transit and at rest; credentials are short-lived and
scoped; each user can only access their own rows; and every sensitive access leaves a trail.

---

## FOR THE FOUNDER — what this layer is

This layer defends against both attackers and accidents. All sections (A–F) are ACTIVE and enforced:
secrets management, row-level security, encryption/OWASP, security testing, network isolation (when
in scope), and the secrets incident runbook.

The credentials problem in plain terms: most apps use one fixed username and password for the
database, unchanged for months. If that leaks, an attacker has the keys to everything until you
manually change them. The fix is three moves:

1. **Dynamic secrets** — instead of one permanent password, the app asks a "secrets engine" for a
   fresh credential each session. It lasts ~1 hour, then dies. Nothing permanent to steal.
2. **Per-service scoping** — each part of your system gets only the access it needs. The API server
   gets read/write to its tables; analytics gets read-only; a background worker gets the job queue
   and nothing else. This is called "least privilege."
3. **Audit logging** — every credential request is recorded: who, when, from which IP, for which
   service. If something goes wrong, you have a full trail instead of a guess.

The payoff phrase from the transcript: your "blast radius shrinks from infinite to just one session."

---

## FOR CLAUDE CODE — rules to enforce

### A. Secrets & credential management (ACTIVE — promoted by founder approval, 2026-07-06)
1. **No static long-lived credentials** in code, config, or environment for production data stores.
   Database/API credentials must be generated dynamically and expire automatically.
2. **Use a secrets engine** — HashiCorp Vault, Infisical, or the cloud provider's native secrets
   manager. The app requests credentials at runtime; they are not baked in.
3. **Short TTL** — issued credentials expire (target ~1 hour or per project policy), then are
   re-requested. No credential outlives its session indefinitely.
4. **Per-service least privilege** — each service/component gets a distinct credential scoped to
   exactly the access it needs (read-only vs read/write vs queue-only). No shared god-credential.
5. **Audit logging on every secret access** — record requester identity, timestamp, source IP, and
   target service. Logs are retained and reviewable.
6. **No secrets in the front end or in version control** (reinforces Layer 1 rule 5 and Layer 7).

### B. Row-Level Security (ACTIVE — promoted by founder approval, 2026-07-06)
   16. Enforce tenant/owner isolation at the database row level as defense-in-depth (works with
       Layer 4 rule 8). Use a dedicated low-privilege DB role, `FORCE ROW LEVEL SECURITY`, and
       pre-filter before queries. Never rely on application code alone for isolation — an app bug must
       not be able to cross tenant boundaries.

### C. Encryption, OWASP Top 10 & security headers (ACTIVE — promoted by founder approval, 2026-07-06)
   17. **Encrypt in transit and at rest** — mandate TLS 1.2+ (disable SSLv3/TLS<1.2), enable HSTS;
       encrypt sensitive data at rest with strong algorithms (AES-256) and managed keys (KMS/HSM with
       rotation). Avoid deprecated crypto (MD5, SHA-1).
   18. **Treat the OWASP Top 10 (2021) as enforceable rules** — A01 Broken Access Control (#1 risk, in
       94% of tested apps), A02 Cryptographic Failures, A03 Injection, A04 Insecure Design, A05
       Security Misconfiguration, A06 Vulnerable/Outdated Components, A07 Identification & Auth
       Failures, A08 Software/Data Integrity Failures, A09 Logging/Monitoring Failures, A10 SSRF.
   19. **Security headers on all responses** (OWASP Secure Headers): CSP (strongest XSS defense —
       avoid `unsafe-inline`/`unsafe-eval`; deploy report-only first), HSTS (`max-age` ≥ 6 months,
       `includeSubDomains`), `X-Content-Type-Options: nosniff`, `frame-ancestors`/`X-Frame-Options`,
       `Referrer-Policy`, `Permissions-Policy`.
   20. **Supply-chain security** — maintain a dependency inventory (SBOM), continuously scan for CVEs,
       pin versions, use only trusted sources. (Ties to Layer 7 CI scanning.)
   21. **Least privilege everywhere** — every user, service, token, and DB role gets the minimum
       access needed.
   22. **Validation vs sanitization vs output encoding** — apply all three: validation (reject bad
       input; allowlists, parameterized queries against injection), sanitization (clean where needed),
       output encoding (encode on output to prevent XSS — display user data as text, not code).
   23. **CSRF protection** — CSRF tokens and/or `SameSite` cookies on all state-changing requests in
       cookie-based apps.
   24. **Data-privacy awareness** — build with GDPR and India's DPDP Act in mind (CROSS-01).

### D. Security testing — try to hack your own app (ACTIVE — promoted by founder approval, 2026-07-06)
   Having security *features* (RLS, Auth, HTTPS) is not the same as having *verified* security.
   If you have never tried to break your own app, assume someone else will. Three practices:
   7. **Automated vulnerability scan** — run OWASP ZAP (free, one Docker command) against the
      STAGING environment. It crawls the app and tests for the OWASP Top 10 (SQL injection, XSS,
      broken authentication). Fix findings before they reach production.
   8. **Manual authorization testing** — using a tool like Burp Suite, intercept your own requests
      and tamper with them to confirm the API enforces authorization, not just the database:
      - Change the user ID / JWT payload → can you reach another user's data?
      - Change org_id / tenant ID in the request body → can you read another tenant's records?
      - Modify the role claim → can you hit admin endpoints?
      If ANY of these succeed, authorization is broken. **RLS alone is not enough** — the API must
      not pass unchecked parameters straight to the database.
   9. **Continuous security scanning in CI** — security is not a one-time audit, it runs on every
      commit (links to Layer 7):
      - Dependency/code scanning on every push (Snyk or GitHub code scanning) via GitHub Actions.
      - Secret scanning on every PR (GitGuardian or TruffleHog) to catch hard-coded secrets.

The principle: **scan, intercept, automate.** These are the same tools a pen-testing firm uses —
run them yourself, before the breach, not after.

### E. Network isolation & data residency — for high-security / private-AI builds (ACTIVE when in scope — promoted by founder approval, 2026-07-06)
   Applies when the requirement is that sensitive data, compute, and model weights **never leave a
   private network** (e.g. an enterprise fine-tuning its own LLM, or your CAIO Tracker's private
   intelligence). This is a *compliance requirement, not a preference* — the guarantee must hold as a
   layered defence across storage, compute, IAM, and networking, not a single setting.

   Reference architecture (AWS private-LLM example; adapt to the actual provider):
   10. **Private storage with private transit** — keep training/sensitive data in private S3 reached
       via **VPC Gateway Endpoints**, so transfers stay on the provider's private network and never
       touch the public internet. Encrypt at rest with **customer-managed KMS keys** so the customer,
       not the cloud provider, controls the keys.
   11. **Compute stays inside the private network** — run training/fine-tuning and inference inside
       the VPC via private endpoints and private subnets. Data is pulled from private storage,
       processed, and written back without leaving.
   12. **Least-privilege IAM, scoped per job** — a dedicated role that reads only from the input
       bucket and writes only to the output bucket. No broad permissions. (Reinforces Section A.)
   13. **Private inference endpoint** — serve the model on a private endpoint inside the VPC; apps
       query over private DNS. Zero public exposure.
   14. **Network controls as a hard guarantee** — security groups allow only internal traffic; NACLs
       block all outbound internet at the subnet level; flow logs capture everything. Even on
       misconfiguration, the network catches it before data escapes. (This is the "defence in depth"
       point — multiple independent barriers, not one.)
   15. **End-to-end audit / chain of custody** — log every API call (CloudTrail), every data read
       (S3 access logs), and every inference request, so compliance can trace raw data → model
       response. (Ties to CROSS-01 Compliance and Layer 12.)

If a build states a data-isolation requirement and any of E is missing, treat it as a hard failure,
not a gap — the guarantee only holds if every layer holds.

### F. Secrets incident runbook & rotation schedule (ACTIVE — added by founder approval, 2026-07-06)

🟩 **FOR THE FOUNDER** — Section A stops secrets leaking; this section says what to do WHEN one leaks
anyway (a key pasted into a commit, a laptop stolen, a provider breach). Speed matters more than
blame: a leaked key is being scanned for by bots within minutes of hitting a public repo.

🟦 **FOR CLAUDE CODE — the leaked-secret checklist (execute in this order, immediately):**
25. **Revoke first, investigate second.** The moment a leak is suspected, revoke/rotate the exposed
    credential at the provider. Do not wait to confirm how bad it is — a dead key can't be abused.
26. **Rotate everything the secret could reach.** If a DB password leaked, rotate it AND any secret
    stored where that DB credential gave access. Assume lateral movement.
27. **Purge, don't just delete.** A secret committed to git survives in history. Removing the line is
    NOT enough: rewrite history (`git filter-repo` / BFG) AND treat the secret as burned regardless —
    rotation is mandatory even after purging, because forks/clones/caches may hold it.
28. **Check the audit logs** (Section A rule 5) for any use of the credential between exposure and
    revocation. Unexpected use → treat as a breach → CROSS-01 breach-reporting clock may start
    (72 hours under GDPR/DPDP).
29. **Log the incident** in the project's `techdebt.md` (what leaked, exposure window, log findings,
    actions taken) and append the lesson to `decisions.md`.
30. **Fix the source.** Add/verify secret scanning on every PR (Layer 7 Section B) so the same class
    of leak is caught pre-merge next time.

**Rotation schedule by environment (defaults; a project may tighten, never loosen):**
- **Production:** dynamic short-TTL credentials (rule 3) wherever supported. Static secrets that
  can't be dynamic (e.g. third-party API keys): rotate every 90 days, and immediately on any team
  member/contractor departure.
- **Staging:** separate secrets from production — NEVER shared. Rotate every 180 days.
- **Local development:** each developer uses their own scoped low-privilege credentials via
  `.env` files that are gitignored (verify `.gitignore` covers `.env*` on every project init).
  No production secrets on developer machines, ever.
- **Client-side (SPA/mobile) reality check:** any key shipped to a browser or app IS public —
  no build trick hides it. Keys that must stay secret live server-side only; the client calls
  your API, and your API calls the provider. Client-exposed keys (e.g. Maps, analytics) must be
  domain-restricted and quota-capped at the provider.

If section A, D, F, or E (when in scope) is skipped, list it in the Gap Report with the exposure it leaves.

---

## Checklist — Section A (secrets)
- [ ] No static long-lived DB/API credentials anywhere in prod
- [ ] Secrets engine in use (Vault / Infisical / cloud-native)
- [ ] Issued credentials have a short TTL and auto-expire
- [ ] Each service has its own least-privilege scoped credential
- [ ] Audit logging on every secret access (who/when/IP/service)
- [ ] No secrets in front-end code or version control

## Checklist — Sections B & C
- [ ] RLS enforces tenant/owner isolation at DB level (FORCE RLS, low-privilege role, pre-filter)
- [ ] TLS 1.2+ in transit, HSTS; AES-256 at rest with managed rotating keys; no MD5/SHA-1
- [ ] OWASP Top 10 treated as enforceable rules (esp. A01 broken access control)
- [ ] Security headers set (CSP, HSTS, nosniff, frame-ancestors, Referrer-Policy, Permissions-Policy)
- [ ] Dependency inventory + CVE scanning + pinned versions
- [ ] Least privilege for users/services/tokens/DB roles
- [ ] Validation + sanitization + output encoding all applied
- [ ] CSRF protection on state-changing requests
- [ ] GDPR/DPDP awareness (CROSS-01)

## Checklist — Section D (security testing)
- [ ] OWASP ZAP run against staging; Top 10 findings fixed
- [ ] Manual auth testing done (tamper user ID / org_id / role claim — all correctly blocked)
- [ ] API verified NOT to pass unchecked parameters to the database (RLS is not relied on alone)
- [ ] Dependency/code scanning in CI on every push (Snyk / GitHub code scanning)
- [ ] Secret scanning on every PR (GitGuardian / TruffleHog)

## Checklist — Section F (secrets incident readiness)
- [ ] Leaked-secret checklist known and reachable (this section) — revoke → rotate → purge → audit → log → fix
- [ ] Rotation schedule set per environment (prod 90d static / dynamic TTL; staging 180d; dev gitignored .env)
- [ ] Staging and production secrets fully separated
- [ ] No server-side secrets shipped to client builds; client-exposed keys domain-restricted + quota-capped
- [ ] `.gitignore` covers `.env*` (verified at project init)

## Checklist — Section E (network isolation — only when data-isolation is required)
- [ ] Sensitive data in private storage reached via private endpoints (no public internet)
- [ ] Encryption at rest with customer-managed keys (customer controls keys)
- [ ] Training/inference compute runs inside the private network (private subnets/endpoints)
- [ ] Per-job least-privilege IAM (read input bucket / write output bucket only)
- [ ] Private inference endpoint; apps query over private DNS; zero public exposure
- [ ] Security groups internal-only; outbound internet blocked at subnet (NACLs); flow logs on
- [ ] End-to-end audit trail: every API call, data read, and inference logged

---

## Open questions for the founder (fill in per project)
- Which secrets engine do we standardise on (Vault, Infisical, AWS/GCP native)?
- What credential TTL is acceptable per service (1 hour? shorter for sensitive ones)?
- Where will audit logs be stored and how long retained? (Links to Layer 12.)
- How many distinct service roles does this app have, and what does each truly need access to?
