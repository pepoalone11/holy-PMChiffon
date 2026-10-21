---
name: altra-dev
description: Complete development & implementation workflow for AltraRich Theme and Console — covers Git identity pre-flight, branch naming, submodule 12 ordering rule, UI section/service implementation, and pre-PR proofing. Trigger on /altra-dev, altra-dev, หรือ "พัฒนา altrarich / แก้ไข template altrarich".
---

# Altra Dev — AltraRich Development & Implementation Guide

Standard operating procedure for creating or modifying features in AltraRich.

## 🎯 Scope & Triggers
Trigger when:
- User asks `/altra-dev`, `altra-dev`, หรือ "พัฒนา altrarich / แก้ไข template / เพิ่ม section / เพิ่ม service"
- Starting any coding task in AltraRich Theme or Console.

Local Repositories:
- **Theme:** `/Users/teerawat/ad1/p8-altrarich-master-template-v2-red-dragon-theme`
- **Console:** `/Users/teerawat/ad1/p8-altrarich-frontend`
- **Backend:** `/Users/teerawat/ad1/p8-altrarich-backend` *(Read-only — observe & inspect contracts only)*

---

## 🛑 Step 0: Pre-flight Git Check
Before any git branching, commit, or PR, verify identity:
```bash
git config user.name    # must be pepoalone11
gh auth status          # active account must be pepoalone11
```
If not active, stop and notify user. Never force-switch identity automatically.

---

## 🌿 Step 1: Branch Creation Standard
Always branch from fresh `origin/dev`:
```bash
git fetch origin dev
git switch -c another/<add|fix|update>-<branch-name> origin/dev
```
*(Do NOT branch straight off `main`, and never commit directly onto `dev`).*

---

## 🧩 Step 2: Submodule Ordering Rules (Critical Invariant)
The template shares 12 submodules (`src/constants`, `src/types`, `src/utils`, `src/components/_globals`, etc.):
1. If modifying a submodule file, commit **inside that submodule** and push to branch `latest` directly.
2. Only after `latest` is pushed, bump the submodule pointer in the theme repository on your working branch.
> ⚠️ **Failing to push submodule `latest` first will break CI deploys for all themes!**

---

## 💻 Step 3: Implementation Patterns

### A. UI Section (`src/components/_sections/`)
- Place sections under `src/components/_sections/<SectionName>/`
- Structure:
  - `index.tsx`: Root section component
  - `_modules/`: Local child components used only within this section
  - `use<SectionName>.ts`: Local hook for logic/data-fetching
- Ensure loading, error, and empty states are handled.
- Use Tailwind CSS classes exclusively.

### B. Service Method (`src/services/`)
- Define request and response types in `src/types/`
- Service method calls API via the shared HTTP client.
- Return strongly-typed responses; handle network exceptions gracefully.

---

## ✅ Step 4: Pre-PR Proofing Checklist
Before opening a PR, run all verification steps:
```bash
npx tsc --noEmit
pnpm lint
pnpm lingui
```
Confirm:
1. Zero TypeScript errors
2. ESLint clean (no stripped imports)
3. Lingui missing count is 0

---

## 🚀 Step 5: PR & Merge Gate
- Push branch: `git push -u origin another/<add|fix|update>-<branch-name>`
- Open PR targeting base branch `dev`:
  ```bash
  gh pr create --base dev --title "another(<scope>): <description>"
  ```
- **Rule:** Merge into `dev` only. **Never merge into `main` and never push a version tag** (production deployment is managed by `@MM-ad1-agent`).
