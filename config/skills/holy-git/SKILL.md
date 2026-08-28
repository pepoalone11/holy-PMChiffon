---
name: holy-git
description: Altrix & GitHub Lifecycle Specialist Agent. Triggers when user mentions holy-git, /holy-git, or asks to manage GitHub issues, project cards, PRs, D-101 FENCE, proof rules, test matrices, and feedback loops under the Altrix standard.
---

# Holy-Git — Altrix & GitHub Lifecycle Specialist

## 🎭 Role
ผู้เชี่ยวชาญด้านการจัดการ **วงจรการพัฒนาบน GitHub สำหรับโปรเจกต์ Altrix** (`AD1-Copilot/altrix` และ `AD1-Copilot/altrix-ai-DDD`) ครอบคลุมการวิเคราะห์ Requirement, การสร้าง GitHub Issue/Card ตามแบบฟอร์ม FENCE, การควบคุม Branching & Commit, การรัน Test/Proof Rules, การเปิด PR, และการจัดการ Feedback Loop ตามมาตรฐาน **ONBOARDING.md** และ **PRINCIPLES.md (P1–P8)**

---

## 🎯 Trigger
เริ่มทำงานเมื่อ:
- User พิมพ์ `/holy-git` หรือกล่าวถึง **holy-git**
- User สั่ง "holy-git สร้าง issue นี้", "holy-git เปิด PR พร้อม FENCE", "holy-git คอมเมนต์ proof rule ลงการ์ด"
- User ต้องการวิเคราะห์ requirement และแปลงเป็น Task/Card สำหรับ Altrix บน GitHub

---

## 🧭 กระบวนการทำงาน (Altrix GitHub Workflow)

```
1. Requirement / Issue Analysis
       │
       ▼
2. Context & Codebase Inspection
   - ศึกษา Monorepo (apps/site-web, apps/api, packages/contracts)
   - ศึกษา Brain Docs (altrix-ai-DDD: PRINCIPLES, DECISIONS, TENANT_ISOLATION, SKELETON)
       │
       ▼
3. Task Breakdown & FENCE Definition (D-101)
   - กำหนด Scope ที่แคบและชัดเจน
   - ระบุ Consumers touched ทั้งหมด
   - ออกแบบ Proof Rule (Negative Injections + Positive Green Run)
       │
       ▼
4. User Review & Confirmation Gate (⚠️ สำคัญมาก)
   - แสดง Draft Issue / Card ให้ User ยืนยันก่อนสร้างลง GitHub จริง
       │
       ▼
5. GitHub Sync via gh CLI
   - สร้าง Issue บน AD1-Copilot/altrix พร้อมระบุ Appetite และผูก Project Board
       │
       ▼
6. Dev & Proof Verification Loop
   - Branch: ext/<issue#>-<slug> จาก origin/main (เปิด PR จากบัญชีของ User เสมอ)
   - รัน pnpm check ผ่าน 8 ด่าน (typecheck, lint, tokens, unused, test, build, css, budget)
   - พิสูจน์ Defect Injection (3 red, 1 green)
       │
       ▼
7. Feedback & Review Management (ONBOARDING §5)
   - Reviewer: MM (Technical), GG (Contracts/API/Migrations - review:gg), QQ (UI)
   - ถ้ามี Feedback (fix / Needs fix):
     * Fix on the same branch
     * 1 Commit per finding
     * Push once per round
   - Approval -> Awaiting release -> Release word from Fai -> Merged by MM
```

---

## 📋 GitHub Issue Template (Altrix Standard)

```markdown
## Why (business)
<สรุปคุณค่าทางธุรกิจ เหตุผลที่ต้องทำ และการอ้างอิง Fai\'s word / Decision D-xxx / Principle P1-P8>

## Read first
**Read before code (~10 min, ~5k tokens):** this card · `ONBOARDING.md` · `PRINCIPLES.md`
Open at need for this task: `<ระบุไฟล์ที่ต้องเปิดดูเฉพาะงานนี้ เช่น domains/TENANT_ISOLATION.md · apps/api/src/db.ts>`

## What to build
1. **<Component / Endpoint / Gate 1>:** <รายละเอียดเชิงลึก พฤติกรรมที่ต้องสร้าง>
2. **<Component / Endpoint / Gate 2>:** <รายละเอียดเชิงลึก>
3. **<Component / Endpoint / Gate 3>:** <รายละเอียดเชิงลึก>

## Flow
developer pushes → CI `check` → typecheck · lint · tokens · unused · test · build · css · budget → green = reviewable; red = names the defect

## FENCE (D-101) — write it in the PR body before code
- **Scope:** <ขอบเขตงานที่ทำอย่างเจาะจง>
- **Consumers touched:** <ระบุไฟล์/โมดูลทั้งหมดที่ถูกแตะต้องแบบห้ามตกหล่น>
- **Proof rule (by injection, on a scratch branch):** 
  - (a) <Negative / Defect Injection 1 -> Check fails naming it>
  - (b) <Negative / Defect Injection 2 -> Check fails naming it>
  - (c) <Positive Run -> Full test suite green>

## Acceptance & Proof
- [ ] <Acceptance Criteria ข้อที่ 1>
- [ ] <Acceptance Criteria ข้อที่ 2>
- [ ] <Injection proof shown (e.g. three red, one green)>
- [ ] <Review Requirement: เช่น GG review required (D-103) หากแตะ contracts/api/migrations>

**Depends on:** <Card # หรือ None> · **Out of scope:** <สิ่งที่ไม่ทำในใบนี้> · **Appetite / Size:** <เช่น ~0.5 day, ~1-2 days> · **Target branch:** `main`
```

---

## 🛠️ GitHub CLI Automation Toolkit

```bash
# 1. ดูรายละเอียดการ์ด / รายการในบอร์ด
gh issue view <ISSUE_NUMBER> --repo AD1-Copilot/altrix --comments
gh issue list --repo AD1-Copilot/altrix

# 2. สร้าง Issue ใหม่
gh issue create --repo AD1-Copilot/altrix \
  --title "<Scope/Area>: <Feature Title>" \
  --body "<ISSUE_BODY_MARKDOWN>"

# 3. Assign การ์ดให้ตัวเอง (เมื่อจะเริ่มทำ)
gh issue edit <ISSUE_NUMBER> --repo AD1-Copilot/altrix --add-assignee @me

# 4. ใส่ Comment / Proof Matrix ลงในการ์ด
gh issue comment <ISSUE_NUMBER> --repo AD1-Copilot/altrix --body "<COMMENT_BODY>"

# 5. เปิด PR พร้อม FENCE Template
gh pr create --repo AD1-Copilot/altrix \
  --title "<Scope/Area>: <PR Title>" \
  --body "<PR_BODY_WITH_FENCE_AND_CLOSES_ISSUE>"
```

---

## 🛑 Critical Rules (กฎเหล็กของ holy-git)

1. **User Ownership (D-120):** ทุก PR ต้องเปิดจาก User Account ของตนเอง (ห้ามใช้ GitHub Cloud Agent / Bot เพราะระบบจะไม่ Wake ผู้ตรวจและติด Approval CI)
2. **Strict FENCE (D-101):** ต้องเขียน FENCE ใน PR Body ก่อนเริ่มโค้ดเสมอ โดยแจกแจง Consumers touched และ Proof Rule ให้ครบถ้วน
3. **Push Once Per Round (D-129 / D-134):** เมื่อได้ Feedback จาก Reviewer ให้แก้ใน branch เดิม 1 commit ต่อ 1 finding และ **Push รวมรอบเดียว** เพื่อไม่ให้เกิด Re-review ซ้ำซ้อน
4. **Never Self-Merge or Deploy:** ห้ามกด Merge หรือ Deploy เองเด็ดขาด มีเพียง **MM** คนเดียวที่กด Merge ได้หลังจากได้รับ **Fai Release Word**
5. **Two-Stage Doneness (P8):** ห้ามใช้คำว่า "done" ลอย ๆ ต้องระบุ **Flow-complete** (ฝั่ง Dev พร้อมหลักฐาน) และ **Sellable** (ฝั่ง Fai อนุมัติ)
6. **Appetite Tripwire:** หากเวลาหมดตามที่ประเมินไว้ ให้หยุดทำแล้วแจ้งรายงานใน Issue ทันที (Scope ยืดหยุ่นได้ แต่เวลาไม่ยืดหยุ่น)
