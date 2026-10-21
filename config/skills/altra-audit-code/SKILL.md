---
name: altra-audit-code
description: Scan AltraRich codebase (Template or Console) against architectural rules, sharing submodule rules, and strict house guidelines. Trigger on /altra-audit-code, altra-audit-code, /audit-code, หรือ "ตรวจโค้ด altrarich".
---

# Altra Audit Code — AltraRich Code Compliance Scanner

Audits source code (`src/`) in AltraRich repositories against strict architectural and quality rules.

## 🎯 Scope & Triggers
Trigger when:
- User asks `/altra-audit-code`, `/audit-code`, `altra-audit`, หรือ "ตรวจโค้ด altrarich / audit rules"
- Prompt mentions scanning compliance for AltraRich code.

Target Repositories:
- **Theme:** `/Users/teerawat/ad1/p8-altrarich-master-template-v2-red-dragon-theme`
- **Console:** `/Users/teerawat/ad1/p8-altrarich-frontend`

---

## 🔍 Core Audit Checklist

### 1. Component & UI Discipline (`.claude/sharing/rules/components.md`)
- ❌ **No `any`:** Disallow `any` in props, states, or return types.
- ❌ **No Inline Styles:** Use Tailwind classes only (no `style={{ ... }}`).
- ❌ **Missing States:** Components with asynchronous data must provide explicit:
  1. Loading State
  2. Error State
  3. Empty State
- ✅ **Props Interface:** Every component must declare typed props (`interface Props` or `type Props`).

### 2. Locales & Lingui i18n (`.claude/sharing/rules/locales.md`)
- ❌ **Bare String Hazard:** Never store bare untranslated strings in constants.
- ✅ **Thunk Pattern:** In constant files, strings must be stored as thunks:
  ```typescript
  { message: () => i18n.t`Key.Message` }
  ```
  *(Bare strings get purged by `lingui extract --clean` during `pnpm dev` or `pnpm build`)*.
- ✅ Confirm `missing count == 0` for all locales.

### 3. Financial & Turnover Safety (House Rules)
- ❌ **No Javascript Floats / float8:** Never use floating-point math for money, balances, commission, or turnover.
- ✅ **Decimal Math:** Must use `NUMERIC(18, 4)` / Decimal.js / Shopspring Decimal.
- ✅ **Amount Display:** Be aware of `amount(100000)` turning into `100k` by default. For exact currency displays, require `{ format: '0,0.[00]' }`.

### 4. Next.js App Router Invariants
- ❌ **Private Folders:** Folders prefixed with `_` (e.g. `src/app/_test`) are private and will 404 if intended as routes.

---

## 🛠️ Execution Steps
1. **Confirm Scope:**
   - Changed files in branch (`git diff --name-only origin/dev`)
   - Specific component or section
   - Full sweep of `src/`
2. **Execute Scan:** Inspect targeted `.ts` / `.tsx` files against the checklist above.
3. **Report Findings:**
   - Group by Severity: 🔴 Must-Fix (Broke build/rules), 🟡 Warning (Code smell), 🟢 Passed
   - Provide file link, line range, problem explanation, and drop-in code fix.
