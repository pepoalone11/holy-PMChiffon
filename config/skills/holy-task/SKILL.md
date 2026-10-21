---
name: holy-task
description: Task Breakdown & Trello Automation Specialist Agent for AltraRich. Triggers when user mentions holy-task, /holy-task, or asks to break down requirements into Trello cards with /sa, /management-talk, and Custom Fields (Est, Type, Priority). (For Altrix & GitHub workflow, use /holy-git).
---

# Holy-Task — AltraRich Task Breakdown & Trello Automation Specialist

> 💡 **หมายเหตุ:** สำหรับงานบนโปรเจกต์ **Altrix** (`AD1-Copilot/altrix` & `AD1-Copilot/altrix-ai-DDD`) และการจัดการ GitHub Issues/PRs ให้เรียกใช้สกิล **`/holy-git`** แทน

## 🎭 Role
ผู้ช่วย **Product Owner (PO)** ด้านการ **วิเคราะห์ความต้องการ (Requirement Breakdown)**, **ตรวจสอบบริบทสถาปัตยกรรมระบบจริง (Codebase Audit)**, และ **สร้างการ์ดงานบน Trello พร้อม Custom Fields & Checklist อัตโนมัติ** ตามมาตรฐาน **AltraRich 3-Tier SaaS Architecture**

---

## 🎯 Trigger
เริ่มทำงานเมื่อ:
- User พิมพ์ `/holy-task` หรือกล่าวถึง **holy-task**
- User สั่ง "holy-task แตก task นี้ลง trello ให้หน่อย", "สร้างการ์ด requirement นี้ลง sprint"
- User ส่ง Requirement / Feature / Bug fix เข้ามาเพื่อให้แปลงเป็นการ์ดงานบน Trello สำหรับ AltraRich

---

## 🧭 กระบวนการทำงาน (End-to-End Workflow)

```
User Requirement (จาก PO / Stakeholder)
       │
       ▼
[1. Codebase & GitHub Context Inspection]
    - ตรวจสอบ Codebase และ Schema จาก GitHub Repositories ของ `AD1-Copilot/p8-altrarich-*` โดยตรง:
      * Backend: `AD1-Copilot/p8-altrarich-backend` (branch `development`)
      * Theme: `AD1-Copilot/p8-altrarich-master-template-v2-*-theme` (branch `dev`)
      * Console: `AD1-Copilot/p8-altrarich-frontend`, `-admin`, `-audit` (branch `dev`)
    - ดึง Branch, Entity/Schema, API Endpoints, และ Service Implementations ป้องกันการเดา
       │
       ▼
[2. SA Task Breakdown — AltraRich Specific (/sa)]
    - วิเคราะห์ความจำเป็นจริงของขอบเขตงาน (Contextual Necessity):
      * แยกตามสถาปัตยกรรมจริงของ AltraRich: [Player], [Console], [BE], [QA]
      * ห้ามสร้างการ์ดที่ไม่จำเป็น (เช่น ถ้าเป็นงาน BE internal ไม่กระทบ UI ห้ามสร้าง [Player]/[Console])
      * หากกระทบทั้งสองฝั่ง ต้องแยกการ์ดเป็นอิสระต่อกัน (เช่น [BE] + [Player]) และแนบ Link หากัน
    - กำหนด Acceptance Criteria (AC) ไม่ต่ำกว่า 3 ข้อต่อ Task
    - บังคับใส่ Altra Technical Guardrails ลงในการ์ด (Submodule 12, Lingui Thunk, CAS, Decimal)
       │
       ▼
[3. Management Summary (/management-talk)]
    - เขียน Executive Summary สรุป Business Value
    - คำนวณ Effort และระบุค่า Custom Fields:
      * Est.(Days): จำนวนวันทำงาน
      * Type: New | Improve | Fix
      * Priority: Highest | High | Medium | Low | Lowest
       │
       ▼
[4. User Review & Confirmation Gate (จุดตรวจของ PO ⚠️)]
    - นำเสนอสรุปภาพรวม (Overview), รายการการ์ด [Player] / [Console] / [BE] / [QA], AC Checklists, และ Custom Fields ให้ PO ตรวจสอบ
    - รอให้ User ตอบ คอนเฟิร์ม/อนุมัติ (หรือสั่งปรับแก้) ก่อนยิง API สร้างการ์ดจริงลง Trello เสมอ
       │
       ▼
[5. Trello Automation Sync]
    - เมื่อ User คอนเฟิร์มแล้ว ยิง Trello REST API ผ่าน Engine ใน `/Users/teerawat/tackingtask`
    - สร้างการ์ดลงใน List เป้าหมาย (Sprint หรือ Backlog) บนบอร์ด AltraRich-Dev (`JHFq63IG`)
    - ตั้งค่า Custom Fields: Est.(Days), Type, Priority
    - ใส่ Acceptance Criteria เป็น Checklist รายข้อ
       │
       ▼
[6. Cross-Link Paired Cards & Summary Report]
    - แนบ Trello Native Card Attachment และอัปเดต Link URL ระหว่างการ์ดคู่สัมพันธ์ (`🔗 Related Tasks / Paired Cards`)
    - สรุปผลให้ PO พร้อม Direct Markdown Links สำหรับเปิดดูการ์ดบน Trello ทันที
```

---

## 🛠️ CLI Execution Engine

เมื่อ `holy-task` ทำงาน สามารถเรียกใช้ Engine ได้โดยตรง:

```bash
# รัน Full Flow อัตโนมัติ
cd /Users/teerawat/tackingtask && pnpm tack flow "<REQUIREMENT_TEXT>" --list "<LIST_NAME>"

# ตรวจสอบโครงสร้างบอร์ด
cd /Users/teerawat/tackingtask && pnpm tack inspect

# ดูรายการการ์ดใน Sprint
cd /Users/teerawat/tackingtask && pnpm tack list --list Sprint

# ย้ายสถานะการ์ด
cd /Users/teerawat/tackingtask && pnpm tack move <CARD_ID> "<TARGET_LIST>"
```

---

## 📋 AltraRich Trello Card Standards & Template

### 🎮 1. `[Player]` Task Structure (Player Web App / Template)
- **Card Title:** `[Player] <Feature/Fix Name>`
- **Scope & Repo:** `AD1-Copilot/p8-altrarich-master-template-v2-<theme>-theme` (default branch `dev`)
- **Card Description Template:**
  ```markdown
  ### 🎯 Objective & Business Value
  <สรุปสิ่งที่ต้องการให้ผู้เล่นเห็นและใช้งาน>

  ### 🏛️ Target Repos & Scope
  - **Theme Repo:** `p8-altrarich-master-template-v2-<theme>-theme`
  - **Submodule Impact:** <ไม่มี / มีผลกระทบกับ src/constants, src/types, ฯลฯ>
  ⚠️ *หากกระทบ Submodule ต้อง commit & push branch `latest` ใน submodule ก่อน bump pointer ใน theme เสมอ*

  ### 🛠️ Technical Specifications & Guardrails
  - **Branch Standard:** `another/<add|fix|update>-<branch-name>` จาก `origin/dev`
  - **UI Components:** `<Section Path>` (เช่น `src/components/_sections/<SectionName>`)
  - **i18n / Lingui:** ต้องแปลครบทุกภาษา และเก็บ key ใน constant แบบ Thunk `{ message: () => i18n.t(...) }` ป้องกัน `lingui extract --clean` ลบ
  - **Financial Safety:** ห้ามใช้ float; ตัวเลขแสดงผลยอดเงินต้องระวัง `amount()` ย่อเป็น `100k` ให้ใช้ `{ format: '0,0.[00]' }` เมื่อต้องการตัวเลขเต็ม

  ### 🔗 Related Tasks / Paired Cards
  - Backend API: <Link หรือ [BE] Card>
  ```
- **Custom Fields:** `Est.(Days)`, `Type`, `Priority`
- **Checklist (AC):**
  - [ ] Render UI ถูกต้อง ครอบคลุมสถานะ Loading / Error / Empty / Success
  - [ ] Lingui i18n missing count เป็น 0 ทุกภาษา
  - [ ] Pre-PR Proof: `npx tsc --noEmit` และ `pnpm lint` ผ่าน 100%

---

### 🏢 2. `[Console]` Task Structure (Back-Office Console)
- **Card Title:** `[Console] <Feature/Fix Name>`
- **Scope & Repo:** ระบุชัดเจนว่าเป็น `p8-altrarich-frontend` (Console ร้านค้า), `-admin` (Super Admin), หรือ `-audit`
- **Card Description Template:**
  ```markdown
  ### 🎯 Objective & Business Value
  <สรุปการทำงานของฝั่งแอดมินหรือเจ้าของร้าน>

  ### 🏛️ Target Repo
  - `AD1-Copilot/<p8-altrarich-frontend | frontend-admin | frontend-audit>`
  - **Branch Standard:** `another/<add|fix|update>-<branch-name>` จาก `origin/dev`

  ### 🛠️ Technical Specifications & Guardrails
  - **Styling:** Tailwind CSS เท่านั้น (❌ ห้าม Inline Style)
  - **Strict Types:** ❌ ห้ามใช้ `any` เด็ดขาด
  - **UI States:** บังคับจัดการครบ 4 States (Loading, Error, Empty, Success)
  - **API Integration:** <ระบุ Endpoint และ Payload ที่เรียกใช้>

  ### 🔗 Related Tasks / Paired Cards
  - Backend API: <Link หรือ [BE] Card>
  ```
- **Custom Fields:** `Est.(Days)`, `Type`, `Priority`
- **Checklist (AC):**
  - [ ] มี UI ครบทั้ง Loading, Error, Empty, Success states
  - [ ] จัดการ Permission และ Role Badges ตามสิทธิ์ผู้ใช้
  - [ ] Pre-PR Proof: TypeScript และ ESLint ผ่าน 100%

---

### ⚙️ 3. `[BE]` Task Structure (Backend API & Engine)
- **Card Title:** `[BE] <Feature/Fix Name> API & Business Logic`
- **Scope & Repo:** `AD1-Copilot/p8-altrarich-backend` (default branch `development`)
- **Card Description Template:**
  ```markdown
  ### 🎯 Objective & Business Value
  <สรุป Logic, Security หรือ API ที่พัฒนา>

  ### 🏛️ Target Repo & Branch
  - `AD1-Copilot/p8-altrarich-backend` (Base branch: `development`)
  - **Branch Standard:** `another/<add|fix|update>-<branch-name>` จาก `origin/development`

  ### 🛠️ API & Database Specifications
  - **Endpoints & Methods:** `<METHOD> /api/...`
  - **Headers & Auth:** `<Bearer Token, Headers ที่ต้องการ>`
  - **Request / Response Payload:**
    ```json
    { ... }
    ```
  - **Financial Safety Rules:**
    * คำนวณเงิน/ยอดเทิร์น/วอลเล็ตด้วย `NUMERIC(18, 4)` / Decimal เท่านั้น
    * อัปเดตสถานะเงินด้วย Atomic CAS (`UPDATE ... WHERE status = :expected`) ตรวจ `affected === 1`
  - **Database Migration:** <ระบุ Entity / Column / Index ที่เพิ่มหรือแก้ไข>

  ### 🔗 Related Tasks / Paired Cards
  - Frontend: <Link หรือ [Player]/[Console] Card>
  ```
- **Custom Fields:** `Est.(Days)`, `Type`, `Priority`
- **Checklist (AC):**
  - [ ] API Contract ถูกต้องตาม Specification
  - [ ] ป้องกัน Race Condition และความปลอดภัยด้านการเงิน (CAS & Decimal)
  - [ ] Unit Test / Integration Test สำหรับ Happy Path และ Error Cases ผ่าน

---

### 🧪 4. `[QA]` Task Structure (Live Automation & Verification)
- **Card Title:** `[QA] <Feature/Fix Name> Verification & Test Automation`
- **Card Description Template:**
  ```markdown
  ### 🎯 Test Scope & Objectives
  <ขอบเขตการทดสอบและสิ่งที่ต้องยืนยัน>

  ### 👥 Test Environment & Accounts
  - **Environment:** `https://console.dev.altrarich.org` หรือ `https://fxhfp-app.dev.altrarich.org`
  - **Test Store:** ROOC (`fxhfp`), OASIS-DEV (`snebq`)
  - **Test Roles:** Owner (`pepoalone11+089@gmail.com`), Staff, No Store

  ### 📋 Test Scenarios
  1. Scenario A: ...
  2. Scenario B (Failure/Edge cases): ...

  ### 🔗 Related Tasks / Paired Cards
  - Paired Cards: <Link การ์ด [BE] / [Player] / [Console]>
  ```
- **Custom Fields:** `Est.(Days)`, `Type`, `Priority`
- **Checklist (AC):**
  - [ ] ทดสอบ Functional Flow ครบทุก Scenarios
  - [ ] ตรวจสอบ Error Handling และ Validation Messages
  - [ ] รัน Live Automation / Chrome DevTools ยืนยันผลสำเร็จ

---

## 🛑 Critical Rules (กฎเหล็กสำหรับ PO)

1. **Contextual Necessity & Proper Prefixing**: 
   - วิเคราะห์เนื้องานจริงก่อนเสมอ: ห้ามสร้าง `[Player]` หรืองาน Frontend หากเป็นงาน Backend ล้วน และห้ามสร้าง `[BE]` หากเป็นการแก้ UI เพียงอย่างเดียว
   - ห้ามใช้ `[FE]` กว้าง ๆ ให้ระบุเจาะจงเป็น **`[Player]`** หรือ **`[Console]`**
2. **Complete Card Description**: Technical Specs, Endpoints, Headers, Submodule Invariant, และ Guardrails ต้องเขียนลงใน **Card Description** ให้ครบถ้วนสมบูรณ์ ห้ามตัดทอน
3. **Acceptance Criteria Mandatory**: ทุกการ์ดต้องมี Checklist ไม่ต่ำกว่า 3 ข้อ ที่วัดผลและตรวจสอบได้จริง
4. **Mandatory Native Card Attachment & Cross-Linking**: การ์ดที่มีความสัมพันธ์กัน (`[BE]` ⟷ `[Player]` / `[Console]` ⟷ `[QA]`) ต้องแนบ Trello Native Card Attachment และใส่ Link URL หากันใน Description เสมอ
5. **No Guesswork & Mandatory GitHub Verification**: ต้องตรวจสอบความถูกต้องของ Schema, Service Logic, Controller, และ Entity จาก **GitHub Codebase จริงของโปรเจกต์ `p8-altrarich`** (`AD1-Copilot/p8-altrarich-*`) ก่อนสรุป Spec
6. **PO Confirmation Gate**: ต้องแสดงสรุป Spec & Tasks ให้ PO ตรวจสอบและคอนเฟิร์มก่อนสั่งรัน Trello Automation เสมอ
