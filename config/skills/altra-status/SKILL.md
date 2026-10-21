---
name: altra-status
description: Snapshot of the AltraRich repos across template (10 themes), console (3 apps), and backend — dev vs main, open PRs, CI Deploy, and submodule pointer drift. Trigger on /altra-status, altra-status, หรือ "เช็คสถานะ altrarich".
---

# Altra Status — AltraRich Ecosystem Snapshot

Read-only sweep of the AltraRich ecosystem repos under `AD1-Copilot`. Never modifies, clones, or pushes.

## 🎯 Scope & Triggers
Trigger when:
- User asks `/altra-status`, `altra-status`, หรือ "เช็คสถานะ altrarich / เช็ค pr / เช็ค ci"
- Optional argument: `template`, `console`, `backend`, หรือไม่มี argument (ตรวจครบทั้ง 3 ฝั่ง)

---

## 🛑 Pre-flight Check
Account check first before running `gh` calls:
```bash
git config user.name    # must be pepoalone11
gh auth status          # active account must be pepoalone11
```
If wrong or inactive, stop and alert user immediately.

---

## 1. ฝั่ง Template (10 Themes)
Themes: `xd`, `auto-blue`, `bets365`, `lucky7`, `orange`, `pink`, `red-dragon`, `saturvin`, `star168`, `vk168`  
Repo pattern: `AD1-Copilot/p8-altrarich-master-template-v2-<theme>-theme`

Per repo sweep:
- **dev HEAD:** `gh api repos/<R>/commits/dev --jq '{sha:.sha[0:7], msg:(.commit.message|split("\n")[0]), author:.commit.author.name, date:.commit.author.date}'`
- **compare main...dev:** `gh api repos/<R>/compare/main...dev --jq '{ahead:.ahead_by, behind:.behind_by}'`
- **open PRs:** `gh pr list -R <R> --state open --json number,title,baseRefName,headRefName,author`
- **CI Deploy on dev:** `gh run list -R <R> --branch dev --workflow Deploy --limit 1 --json status,conclusion`
- **Submodule Pointer (e.g. constants):** `gh api repos/<R>/contents/src/constants?ref=dev --jq '.sha[0:7]'`

### Report Format
| Theme | dev | main | PRs | CI | Submodule Pointer |
|---|---|---|---|---|---|
| `red-dragon` | `abc1234` | in sync / ahead N | #4 another/fix-x | 🟢 success | `f1a2b3c` |

---

## 2. ฝั่ง Console (3 Apps)
Repos: `AD1-Copilot/p8-altrarich-frontend`, `p8-altrarich-frontend-admin`, `p8-altrarich-frontend-audit`  
*(No shared submodules; each app has independent commits)*

Per repo sweep:
- **dev HEAD:** `gh api repos/<R>/commits/dev --jq '[.sha[0:7],(.commit.message|split("\n")[0]),.commit.author.date]|@tsv'`
- **compare main...dev:** `gh api repos/<R>/compare/main...dev --jq '{ahead:.ahead_by, behind:.behind_by}'`
- **open PRs:** `gh pr list -R <R> --state open --json number,title,baseRefName,headRefName`
- **CI Deploy on dev:** `gh run list -R <R> --branch dev --workflow Deploy --limit 1 --json status,conclusion`

---

## 3. ฝั่ง Backend (Read-only)
Repo: `AD1-Copilot/p8-altrarich-backend`  
> ⚠️ **Backend default branch is `development`, NOT `dev`**

- **development HEAD:** `gh api repos/AD1-Copilot/p8-altrarich-backend/commits/development --jq '[.sha[0:7],(.commit.message|split("\n")[0]),.commit.author.date]|@tsv'`
- **compare main...development:** `gh api repos/AD1-Copilot/p8-altrarich-backend/compare/main...development --jq '{ahead:.ahead_by, behind:.behind_by}'`
- **open PRs:** `gh pr list -R AD1-Copilot/p8-altrarich-backend --state open --json number,title,baseRefName,headRefName`
