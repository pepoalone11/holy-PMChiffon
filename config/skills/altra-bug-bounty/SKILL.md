---
name: altra-bug-bounty
description: Hunt errors and verify post-implementation health in AltraRich — runs TypeScript check, ESLint stripping check, Lingui missing count, and critical runtime edge cases. Trigger on /altra-bug-bounty, altra-bug-bounty, /bug-bounty, หรือ "ตรวจบั๊ก altrarich".
---

# Altra Bug Bounty — Post-Implementation Error Hunter

Automated verification suite to run after modifying any AltraRich code in Theme or Console.

## 🎯 Scope & Triggers
Trigger when:
- User asks `/altra-bug-bounty`, `/bug-bounty`, `altra-bug-bounty`, หรือ "ตรวจบั๊ก altrarich / หา error"
- Automatically recommended after implementing features, bugfixes, or refactoring code in `src/`.

---

## 🔬 Four-Step Verification Protocol

### Step 1: TypeScript Check
In target repo directory:
```bash
npx tsc --noEmit
```
Verify zero compiler errors.

### Step 2: ESLint & Import Stripping Check
In target repo directory:
```bash
pnpm lint
```
> ⚠️ **ESLint Auto-fix Warning:** The repository hooks run `eslint --fix` on write. If an import was added but not immediately referenced in code, ESLint might strip it out silently. Always verify that imported components, hooks, or context providers are preserved.

### Step 3: Lingui Translation Completeness
In target repo directory:
```bash
pnpm lingui
```
Verify that the output reports **missing count: 0** across all 5 `.po` catalogs (`th`, `en`, `zh`, etc.).

### Step 4: Critical Runtime Edge Cases
Inspect changed files for known AltraRich traps:
1. **Amount Formatter Abbreviation:** Check if `amount(val)` is called on values $\ge 1,000$. If exact currency is required, ensure `{ format: '0,0.[00]' }` is passed (preventing `100k` bug).
2. **Next.js Private Route Trap:** Ensure route folders do not start with `_` unless intentionally private.
3. **Submodule Pointer Drift:** If any file in `src/components/_globals`, `src/constants`, `src/hooks`, `src/types`, `src/utils` was modified, check if the change was pushed to submodule branch `latest` before updating pointer in theme.
