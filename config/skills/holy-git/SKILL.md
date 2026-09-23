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

## 🧭 กระบวนการทำงาน (Altrix Workflow — D-205 Standard)

```
1. Requirement / Issue Analysis & Opening
   - เปิดการ์ด (Issue) ลงบน AD1-Copilot/altrix
   - ตกคอลัมน์ Proposed อัตโนมัติ (แจ้งเตือนห้อง #ai-avenger)
   - MM เป็นคนรับการ์ดคนเดียว ตอบภายในวันทำการ ระบุ Holder: ใน §7
       │
       ▼
2. Context & Codebase Inspection
   - ศึกษา Monorepo (apps/site-web, apps/api, packages/contracts)
   - ศึกษา Brain Docs (altrix-ai-DDD: WORKFLOW.md, PRINCIPLES.md, DECISIONS.md)
       │
       ▼
3. Task Breakdown & FENCE Definition (D-101 / D-205)
   - กำหนด Scope ที่แคบและชัดเจน พร้อมระบุ Appetite (นับเป็น "วัน" ตาม D-204)
   - ระบุ Consumers touched ทั้งหมด
   - ตรวจสอบ In-flight Tasks และสถานะ Dev Baseline / Known Regressions (เช่น รายงาน Core Verification ล่าสุด) เพื่อไม่ให้ตัด Scope ชนกับ Spine ที่กำลังทำ (D-142)
   - ออกแบบ Proof Rule (Negative Injections + Positive Green Run)
   - ระบุ "How to see it on dev:" ในการ์ด
       │
       ▼
4. User Review & Image Confirmation Gate (⚠️ สำคัญมากที่สุด)
   - แสดง Draft Issue / Card ให้ User ยืนยันก่อนสร้างลง GitHub จริง
   - 📸 **Mandatory Screenshot & Visual Check:** ตรวจสอบรูปภาพ/Screenshot ที่ User อัปโหลดหรือกล่าวถึงในบริบททั้งหมด
   - **ถามย้ำและขอคอนเฟิร์มรูปภาพเสมอ:** ต้องระบุรายการภาพที่จะแนบ และถาม User เพื่อความชัดเจนเสมอ เช่น:
     *"ตรวจพบภาพหน้าจอ X ภาพ [ระบุชื่อ/คำอธิบายภาพ] ต้องการให้แนบรูปภาพเหล่านี้เข้าไปใน Issue ด้วยทั้งหมดไหม หรือต้องการเลือกรูปใดเป็นพิเศษ?"*
   - **ห้ามสร้างการ์ดโดยไม่มีรูปภาพเด็ดขาด** หากงานนั้นเกี่ยวข้องกับหน้าจอ UI, Bug หรือมีรูปภาพที่ User เคยส่งเข้ามา
       │
       ▼
5. GitHub Sync via gh CLI
   - สร้าง Issue บน AD1-Copilot/altrix พร้อม Appetite และผูก Project Board
       │
       ▼
6. Dev & Proof Verification Loop
   - Branch: ext/<issue#>-<slug> จาก origin/main (เปิด PR จากบัญชีของ User เสมอ — D-120)
   - รัน pnpm check ผ่าน 8 ด่าน (typecheck, lint, tokens, unused, test, build, css, budget)
   - พิสูจน์ Defect Injection (Red -> Green)
       │
       ▼
7. Open PR & Reviewer Routing (D-103, D-205, D-206)
   - เปิด PR แบบ Ready -> ระบบ Lane เรียก Reviewer อัตโนมัติตาม File Path:
     * แตะ D-103 + D-206 (contracts, api, migrations, console screens ที่แตะเงิน): GG ก่อน -> MM หลัง GG approve
     * นอก Path: MM คนเดียว
     * QQ: ตรวจ the look และตรวจบน dev หลัง merge (ยกเว้นมี manual label `review:qq`)
   - ห้าม @mention ลอยๆ เด็ดขาด (ห้าม @ MM กับ GG พร้อมกัน)
   - มีข้อสงสัย @ หาคนเดียว คือ `Holder:` ใน §7 (เรื่อง UI Interaction -> `@ad1-qq-agent`)
       │
       ▼
8. Feedback & Review Circuit Breaker
   - ใส่หลักฐาน Proof ทั้งหมดใน PR Body (ไม่ใช่ comment ตามหลัง)
   - ตอบรีวิวด้วย 1 Comment เดียวหลัง Reviewer ทุกคนส่งผลครบ
   - Reviewer รอบแรกให้ข้อค้นพบครบทุกข้อ ติดป้าย `must-fix` หรือ `follow-up`
   - สิ่งที่บล็อก merge: เงินผิด · security/privacy · ข้อมูลหาย · contract/migration พัง · acceptance ไม่ครบ
   - Push แก้ไขครั้งเดียวต่อรอบ (Fix push) สูงสุด 3 ครั้ง (Cap = 3)
   - หากเกิน 3 ครั้ง หรือพบ Defect ประเภทเดิมซ้ำ = Trigger Circuit Breaker หยุดรีวิว แล้ว Holder + Reviewer ร่วมตัดสินใจในวันเดียว
```

---

## 📋 GitHub Issue Template (Altrix Standard — D-205)

```markdown
## Why (business)
<สรุปคุณค่าทางธุรกิจ เหตุผลที่ต้องทำ และการอ้างอิง Fai's word / Decision D-xxx / Principle P1-P8>

## Read first
**Read before code (~10 min, ~5k tokens):** this card · `ONBOARDING.md` · `PRINCIPLES.md` · `WORKFLOW.md`
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

## How to see it on dev:
<ระบุขั้นตอน/URL ในการเข้าไปทดสอบดูบน dev environment เช่น เข้า /console/crm/... กดปุ่ม...>

## Acceptance & Proof
- [ ] <Acceptance Criteria ข้อที่ 1>
- [ ] <Acceptance Criteria ข้อที่ 2>
- [ ] <Injection proof shown (e.g. three red, one green)>
- [ ] <Review Requirement: GG review required (D-103/D-206) หรือ MM off-path>

## §7 Card Meta
- **Holder:** <MM (default) / QQ (UI-only) / GG (contract/system-shape)>
- **UI impact:** <none / existing pattern / new/changed interaction>
- **QQ graybox:** <link หรือ N/A>
- **Depends on:** <Card # หรือ None>
- **Out of scope:** <สิ่งที่ไม่ทำในใบนี้>
- **Appetite / Size:** <เช่น ~0.5 day, ~1 day, ~2 days (D-204)>
- **Target branch:** `main`
```

---

## 📄 GitHub Pull Request Template (Altrix Standard — D-205)

```markdown
<!-- A dev's card-bound PR: opening it ready rings the first reviewer by itself. Put your evidence HERE, not in a follow-up comment, and do
     not @mention operators to ask for review — need an answer? ONE mention, the card's Holder (altrix-ai-DDD/ONBOARDING.md §5 · WORKFLOW.md).
     An operator-authored PR: automatic events are silent and card-less work has no Holder — the author rings reviewers by canonical
     thread + ONE ping (WORKFLOW.md §2 · §6). -->

## FENCE — D-101, required. A PR without all three lines is returned unreviewed.

- **Scope:** <ระบุขอบเขตงานที่ทำอย่างเจาะจง>
- **Consumers touched, enumerated out loud:** <ทุก surface ที่ diff แตะถึง: components, contract functions, tests, deploy smoke / press-pack>
- **Proof rule:** <คำสั่ง/test ที่พิสูจน์การเปลี่ยนแปลง ต้อง green บน merge preview เทียบกับ main ปัจจุบัน>

## UI consultation — D-174

- **UI impact:** <คัดลอกจาก Task card ให้ตรงเป๊ะ: none | existing pattern | new/changed interaction>
- **QQ graybox:** <N/A | URL ของ image/comment ของ QQ บน Task card>

## Principles — two lines, both required (`PRINCIPLES.md` Enforcement 1 + 5)

- **P-check (ONE line):** <หลักการใดที่มีความเสี่ยงที่สุดใน diff นี้ และทำไมจึงไม่ละเมิด เช่น "P3 — necessary at this scale...">
- **P6 — legacy:** <ระบุ 1 บรรทัด เช่น "Legacy source read: <path> — took X, left Y" หรือ "No legacy counterpart">

## Two-stage doneness — bare "done" is banned (P8)

- Flow-complete: <yes/no + evidence (ผลเทสต์, screenshot ตาม viewport จริง)>
- Sellable: judged by Fai alone — do not claim this axis.
- **How to see it on dev:** <คัดลอกจากบรรทัด §7 ของการ์ด; ระบุเงื่อนไข/ข้อมูล fixture ที่ต้องใช้ทดสอบบน dev>

## Checklist

- [ ] `pnpm check` green on the MERGE PREVIEW (current main + this branch), not only on my branch
- [ ] If `UI impact` is `new/changed interaction`, the QQ graybox is linked above
- [ ] Diff touches NONE of: `packages/contracts/**` · `**/contract.ts` · `apps/api/**` · migrations · the grant model · a console screen that writes or decides money (`console/crm/**` · `console/{Cashback,Referral,Promotion*,Approvals}.tsx` · `console/config/{Money,Currencies}.tsx`) — or a GG PASS is linked here (D-103 · D-206)
- [ ] No hand-typed facts or timestamps added to docs (D-109)
- [ ] No secrets · `deploy/**` or CI files changed only where the card names them (GG review, D-103)

Closes #<ISSUE_NUMBER>
```

---

## 🛠️ GitHub CLI Automation Toolkit

```bash
# 1. ดูรายละเอียดการ์ด / รายการในบอร์ด
gh issue view <ISSUE_NUMBER> --repo AD1-Copilot/altrix --comments
gh issue list --repo AD1-Copilot/altrix

# 2. สร้าง Issue ใหม่ (การ์ดจะตก Proposed อัตโนมัติ MM รับคนเดียว)
gh issue create --repo AD1-Copilot/altrix \
  --title "<Scope/Area>: <Feature Title>" \
  --body "<ISSUE_BODY_MARKDOWN>"

# 3. Assign การ์ดให้ตัวเอง (เมื่อสถานะเป็นการ์ด Ready แล้วจะเริ่มทำ)
gh issue edit <ISSUE_NUMBER> --repo AD1-Copilot/altrix --add-assignee @me

# 4. ใส่ Comment ลงในการ์ด (แท็ก Holder เฉพาะเมื่อมีคำถาม)
gh issue comment <ISSUE_NUMBER> --repo AD1-Copilot/altrix --body "<COMMENT_BODY>"

# 5. การโฮสต์และแนบรูปภาพ UI / Screenshot ลงในการ์ด (สำคัญมาก)
# GitHub Comment จะไม่แรนเดอร์ raw <svg> หรือ HTML tags (ถูกตัดทิ้ง) ต้องฝังผ่าน Image URL เสมอ:
# ก. สร้าง Gist สำหรับโฮสต์ภาพ/SVG:
gh gist create <file.svg> -d "UI Specification" --public
# ข. ดันไฟล์ภาพ .png / .svg ด้วย gh auth token:
cd /tmp/gist_tmp && git push https://<username>:$(gh auth token)@gist.github.com/<gist_id>.git main
# ค. ฝัง Image Markdown ลงในคอมเมนต์:
# ![UI Preview](https://gist.githubusercontent.com/<username>/<gist_id>/raw/<filename>.png)

# 6. เปิด PR พร้อม FENCE Template และ How to see it on dev:
gh pr create --repo AD1-Copilot/altrix \
  --title "<Scope/Area>: <PR Title>" \
  --body "<PR_BODY_WITH_FENCE_AND_CLOSES_ISSUE>"
```

---

## 🛑 Critical Rules (กฎเหล็กของ holy-git ตามมาตรฐาน D-205)

1. **User Ownership (D-120):** ทุก PR ต้องเปิดจาก User Account ของตนเอง (ห้ามใช้ GitHub Cloud Agent / Bot เพราะระบบจะไม่ Wake ผู้ตรวจและติด Approval CI)
2. **Strict FENCE (D-101):** ต้องเขียน FENCE ใน PR Body ก่อนเริ่มโค้ดเสมอ โดยแจกแจง Consumers touched และ Proof Rule ให้ครบถ้วน พร้อมระบุ `How to see it on dev:`
3. **AI Operator Mention & Wake Protocol (D-174 / D-205 / WORKFLOW.md §129):** 
   - **Who a comment wakes:**
     * บนการ์ด/PR: `@MM-ad1-agent` หรือ `@maxine-GG` ปลุกได้ **คนเดียวเท่านั้น** คือ `Holder:` ที่ระบุใน §7 ของการ์ด
     * ด้าน UI / Interaction / Graybox: แท็ก `@ad1-qq-agent` เสมอ (D-174)
   - **ห้าม @mention ลอย ๆ เด็ดขาด:** ห้ามแท็กทั้ง MM และ GG พร้อมกัน "เผื่อไว้" เพราะทุก @mention ปลุก Agent เต็ม 1 session (สิ้นเปลือง token และสร้าง noise มหาศาล)
   - **Ring Rooms (จุดที่การแจ้งเตือนส่งเสียง):**
     * การแจ้งเตือนจาก **Issue / Card** ➔ ส่งเข้า Discord `#ai-avenger`
     * การแจ้งเตือนจาก **PR** ➔ ส่งเข้า Discord `#altrix-ci`
   - **Card-bound hand-off:** ปลุกผ่าน 1 `@mention` บนการ์ดเท่านั้น ไม่ต้องทัก ping ซ้ำในห้อง Discord
   - **อัปเดตงานทั่วไปไม่ต้องแท็กใคร:** หากเป็นการคอมเมนต์อัปเดตสเปก รายงานความคืบหน้า หรือ push code ปกติ ไม่ต้อง @mention ใคร ปล่อยให้ระบบ Lane และบอทหยิบตามรอบอัตโนมัติ
4. **Visual UI, Screenshot Attachment & Graybox Standard (D-174 / D-178 / D-193 Gate 2):**
   - 🚨 **กฎเหล็กการแนบรูปภาพ (MANDATORY IMAGE ATTACHMENT):** เมื่อใดก็ตามที่ User ส่งภาพหน้าจอ, หลักฐาน Defect หรือมีรูปภาพในบริบทการสนทนา **ต้องแนบภาพเข้าไปในการ์ดเสมอ ห้ามลืมเด็ดขาด**
   - 🖼️ **ต้องแสดงภาพในหน้าแชทเสมอ (MANDATORY IN-CHAT EMBED):** เมื่อมีการโฮสต์ภาพขึ้น Gist หรือพูดถึงรูปภาพ **ต้องแสดงรูปภาพในคำตอบแชทด้วย Markdown `![alt](url)` เสมอ** ห้ามใส่แค่ Text URL หรือลิงก์ลอย ๆ เพื่อให้ User และทีมเห็นภาพจริงทันทีโดยไม่ต้องคลิกลิงก์
   - **Dual-Image Proof (Before & After):** หากเป็นงานแก้ไข UI หรือแจ้ง Bug ของหน้าจอ ต้องมีภาพอย่างน้อย 2 มุมมองเสมอ:
     1. ภาพปัญหาเดิม (Current State / Defect)
     2. ภาพ UI ที่เสนอปรับปรุงใหม่ (Proposed UI / Mockup ที่เรนเดอร์สไตล์จริง)
   - **ถามย้ำและขอคอนเฟิร์มรูปภาพก่อนส่งเสมอ:** ก่อนสร้างการ์ดจริง ต้องแจกแจงรายการรูปภาพที่จะแนบ และถามย้ำคอนเฟิร์มกับ User ทุกครั้งว่าต้องการให้ส่งรูปภาพไหนบ้าง
   - **ห้ามส่ง raw XML `<svg>` หรือโค้ด HTML ลงในคอมเมนต์เด็ดขาด** เพราะ GitHub จะ sanitize ตัดทิ้ง ทำให้ผู้ตรวจเห็นเป็นโค้ด text รกตา
   - **วิธีการโฮสต์ภาพ Binary (PNG/JPG) บน Gist ที่ถูกต้อง:**
     * `gh gist create` รับเฉพาะ Text file หากส่ง `.png` ตรง ๆ จะ Error `binary file not supported`
     * ขั้นตอนมาตรฐาน:
       1. สร้าง Text Gist หลอก: `gh gist create /tmp/readme.md -d "UI Specification" --public`
       2. Clone Gist repo: `git clone https://<user>:$(gh auth token)@gist.github.com/<gist_id>.git /tmp/gist_repo`
       3. ก๊อปปี้ไฟล์ภาพ (PNG/SVG) เข้าโฟลเดอร์ `/tmp/gist_repo`
       4. Commit & Push: `git -C /tmp/gist_repo add . && git -C /tmp/gist_repo commit -m "add images" && git -C /tmp/gist_repo push https://<user>:$(gh auth token)@gist.github.com/<gist_id>.git main`
       5. ใช้ Raw URL ตรง: `https://gist.githubusercontent.com/<user>/<gist_id>/raw/<filename>`
     * ฝัง Image Markdown ทั้งใน Issue Body และใน Comment ประกอบการ์ดเสมอ
5. **All Proof in PR Body (D-205):** หลักฐานการทดสอบ (Negative Injection + Green Run, logs, screenshots) ต้องอยู่ใน PR Body เท่านั้น ไม่ใช่ใส่ในคอมเมนต์ตามหลัง
6. **Push Once Per Round & Cap of 3 (D-129 / D-134 / D-205):** 
   - เมื่อได้ Feedback จาก Reviewer ให้ตอบรีวิวด้วย 1 คอมเมนต์เดียวหลัง Reviewer ส่งครบ
   - แก้ใน branch เดิม 1 commit ต่อ 1 finding และ **Push รวมรอบเดียว**
   - จำกัดการ Push แก้ไขได้สูงสุด 3 ครั้ง (Cap = 3) หากเกิน หรือพบข้อค้นพบประเภทเดิมซ้ำ จะหยุดรีวิวทันที (Circuit Breaker) เพื่อให้ Holder และ Reviewer ร่วมตัดสินใจในวันเดียว
7. **Strict Merge Blocker Criteria (D-205):** สิ่งที่บล็อก merge ได้มีเพียง 5 ข้อ:
   - เงินผิด (Money wrong)
   - Security / Privacy
   - ข้อมูลหาย (Data loss)
   - Contract / Migration พัง
   - Acceptance criteria ไม่ครบ
   *(เรื่องราคา ถ้อยคำ PR และเอกสาร ส่งให้ Holder ดูแลตอน release gate ไม่บล็อก dev)*
8. **Never Self-Merge or Deploy:** ห้ามกด Merge หรือ Deploy เองเด็ดขาด มีเพียง **MM** (หรือ GG ตาม D-074) เท่านั้นที่กด Merge ได้
9. **Two-Stage Doneness (P8):** ห้ามใช้คำว่า "done" ลอย ๆ ต้องระบุ **Flow-complete** (ฝั่ง Dev พร้อมหลักฐาน) และ **Sellable** (ฝั่ง Fai อนุมัติ)
10. **Appetite Tripwire:** หากเวลาหมดตามที่ประเมินไว้ ให้หยุดทำแล้วแจ้งรายงานใน Issue ทันที (Scope ยืดหยุ่นได้ แต่เวลาไม่ยืดหยุ่น)
11. **The One Look Principle (D-204 / D-205):** ในขั้นตอน Proposal การ์ดจะได้รับการตรวจเชิงลึกจาก Reviewer (GG ด้าน Contract/Backend หรือ QQ ด้าน UI) เพียง **1 ครั้งเท่านั้น (The One Look)** ความเห็นทางเทคนิคเพิ่มเติมหลังจากนั้นถือเป็น **"Delta Note / Comment" ไม่ใช่รอบตรวจที่สอง** เมื่อสเปกและ Appetite ตกผลึกแล้ว **ต้องส่งตรงหาคุณฝ้ายทันที ห้ามส่งวนกลับไปให้ GG หรือ Reviewer คนเดิมตรวจซ้ำ** เพื่อป้องกันการวนลูป (No review cycle churn)
12. **Dev Baseline & In-Flight Spine Awareness (D-142 / Verification Awareness):** ก่อนตัดการ์ดใหม่หรือกำหนด Proof Rule ต้องตรวจสอบสถานะ Verification บน Dev และ In-flight Tasks เสมอ: หาก Dev มีผลเทสต์ติด RED อยู่ก่อน (เช่น Known Regressions ที่มี Issue รองรับอยู่แล้วอย่าง #413 / PP-08) หรือมีงานที่กำลังแตะ Shared Spine (เช่น `control.tsx`, Layout, Auth, Session) ต้องระบุ `Depends on:` หรือแยก Consumers touched / Out of scope ให้ชัดเจน และต้องไม่เหมาว่า Defect เดิมที่มีอยู่ก่อนเกิดจากการ์ดใหม่
13. **UI Codebase Integrity & In-Component Cohesion (UI ห้ามบอด — อิง Codebase จริง และทำใน Component เดียวกัน):**
    - **ห้ามจินตนาการ UI นอกระบบ:** ก่อนวาด UI ตัวอย่าง ต้องอ่านโค้ดจริงใน `Card.tsx`, `planes.ts`, `measured.ts` และ Component เป้าหมายเสมอ
    - **Altrix Hybrid Skin:** Shell ด้านนอกเป็น Dark Navy (`#181339` / `#1C1842`) แต่เนื้อหาการ์ด (Content Panel / Table) ต้องเป็น **Light Islands (`Card.tsx` / `CONTENT_WARM` `#FAF7F0` / `#FFFFFF`)** ห้ามทำ Dark Card ลอยแปลกแยกเด็ดขาด
    - **In-Component Cohesion:** งานปรับปรุง UI (เช่น Banner, Alert, Action Panel) ต้องออกแบบให้อยู่ **ภายใน Component เป้าหมายเดียวกัน** โดยใช้ Primitives ของระบบ (`Card`, `StatusPill`, `CtaButton`, `GhostButton`) ไม่ใช่สร้าง Widget ลอยภายนอก
