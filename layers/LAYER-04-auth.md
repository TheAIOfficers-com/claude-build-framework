# LAYER 04 — Auth & Permissions

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** Only the right people can do the right things; identity and access are
verified on every request, never assumed.

---

## FOR THE FOUNDER — what this layer is

This is the lock on your front door. "Authentication" checks ID at the door; "authorization" decides
which rooms each person may enter — you need both, on every request. The big architectural choice
(sessions vs tokens) is genuinely debated: sessions are simpler and let you instantly kick someone
out; tokens scale better across mobile apps and many services but are harder to revoke. Practically:
cookie sessions for a normal web app, tokens for mobile/APIs, and store secrets in "httpOnly" cookies
the browser's JavaScript can't read. Modern password advice flips the old rules: **longer beats
complex**, and **forced 90-day changes are now discouraged**. Add multi-factor login, and treat
"forgot password" as the dangerous back door it is.

---

## FOR CLAUDE CODE — rules to enforce

1. **Separate authentication from authorization** — verify *who* (authn) separately from *what they
   may do* (authz). Implement both; never assume authentication implies permission.
2. **Sessions vs JWT — choose per client (a real trade-off, not settled):**
   - Single-domain web app / SPA on your own domain → server-side sessions in an httpOnly, Secure,
     SameSite cookie (easiest to revoke; add CSRF protection on state-changing routes).
   - Mobile/native, third-party API consumers, or many services → short-lived JWT access tokens.
3. **Token storage & rotation** — never store tokens in `localStorage` (XSS-exposed). Standard:
   access token in memory + refresh token in an httpOnly, Secure, SameSite cookie, with refresh-token
   rotation and reuse detection. Access tokens short-lived (~15 min). For JWTs: validate signature,
   `iss`, `aud`, `exp`; never accept `alg: none`; never put PII in the payload (it's only
   base64-encoded, not encrypted).
4. **Passwords (NIST SP 800-63B-4)** — minimum 15 characters when the password is the only factor,
   permit ≥64, accept all printable/Unicode + spaces, allow paste; NO composition rules, NO forced
   periodic rotation. Screen against breach/blocklists; reset only on evidence of compromise. Store
   with a slow salted hash (Argon2, bcrypt, scrypt). Rate-limit login attempts.
5. **MFA** — offer it; prefer phishing-resistant authenticators (FIDO2/WebAuthn passkeys, security
   keys) over SMS/OTP for privileged and externally-facing systems.
6. **OAuth 2.0 / OIDC** for third-party login and delegated access; validate the ID token; store
   nothing sensitive in browser-accessible storage.
7. **Permission model** — start with RBAC (roles → permissions); add ABAC (attribute/context) when
   roles multiply; add ReBAC (relationship-based) for sharing/hierarchies. Always enforce **tenant
   isolation first** (a user's tenant must match the resource's tenant unless global admin).
8. **Row-level security as defense-in-depth** — in multi-tenant systems, enforce isolation at the DB
   row level so an app bug can't cross tenants. Use a dedicated low-privilege role and
   `FORCE ROW LEVEL SECURITY`; pre-filter before expensive operations. (Shared with Layer 8.)
9. **Machine-to-machine auth** — use API keys/service credentials (not user tokens); scope narrowly,
   rotate them. (Ties to Layer 8 secrets.)
10. **Session management** — rotate session ID on login and privilege change, expire idle sessions,
   invalidate on logout everywhere, support concurrent-session control.
11. **Account recovery as an attack surface** — no knowledge-based security questions; identical
   response for valid/invalid accounts (prevent enumeration); rate-limit recovery flows.

🟦 If any rule is skipped, list it in the Gap Report — broken access control is OWASP's #1 risk.

---

## Checklist
- [ ] Authn and authz separated; authz checked on every request
- [ ] Session-vs-token choice made deliberately per client type
- [ ] No tokens in localStorage; refresh-token rotation + reuse detection; short-lived access tokens
- [ ] JWTs validated (sig/iss/aud/exp), no alg:none, no PII in payload
- [ ] Passwords: 15+ char min, no composition rules, no forced rotation, breach-screened, slow hash
- [ ] MFA offered; phishing-resistant for privileged access
- [ ] OAuth/OIDC for third-party login, ID token validated
- [ ] RBAC (→ABAC/ReBAC as needed); tenant isolation enforced first
- [ ] RLS as DB-level defense-in-depth in multi-tenant builds
- [ ] M2M uses scoped, rotated API keys/service creds
- [ ] Session rotation/expiry/invalidation handled
- [ ] Account recovery hardened (no security questions, no enumeration, rate-limited)

---

## Stack note
Default (from STACK.md): **Supabase auth OR Clerk** — choice unresolved per project. Supabase = one
vendor, fewer parts; Clerk = richer auth. Unbundling signal (STACK.md): if you need SSO, custom
claims, or complex multi-tenant logic, move to a dedicated identity layer (Auth0/Clerk/WorkOS).

## Open questions for the founder (fill in per project)
- Supabase auth or a dedicated provider for this build?
- Is it multi-tenant? (If so, RLS + tenant-isolation rules apply hard.)
- What roles/permission tiers exist, and is resource sharing needed (→ ReBAC)?
