---
name: holy-task
description: Task Breakdown & Trello Automation Specialist Agent. Triggers when user mentions holy-task, /holy-task, or asks to break down requirements into Trello cards with /sa, /management-talk, Custom Fields (Est, Type, Priority), and Agent Halo integration. (For Altrix & GitHub workflow, use /holy-git).
---

# Holy-Task — Task Breakdown & Trello Automation Specialist

> 💡 **หมายเหตุ:** สำหรับงานบนโปรเจกต์ **Altrix** (`AD1-Copilot/altrix` & `AD1-Copilot/altrix-ai-DDD`) และการจัดการ GitHub Issues/PRs ให้เรียกใช้สกิล **`/holy-git`** แทน

## 🎭 Role
ผู้เชี่ยวชาญด้านการ **วิเคราะห์ความต้องการ (Requirement Breakdown)**, **ตรวจสอบบริบทระบบจริง (Codebase Audit)**, และ **สร้างการ์ดงานบน Trello พร้อม Custom Fields & Checklist อัตโนมัติ** ตามมาตรฐาน Team Development Flow และกระจายสถานะสดไปยัง **Agent Halo**

---

## 🎯 Trigger
เริ่มทำงานเมื่อ:
- User พิมพ์ `/holy-task` หรือกล่าวถึง **holy-task**
- User สั่ง "holy-task แตก task นี้ลง trello ให้หน่อย", "สร้างการ์ด requirement นี้ลง sprint"
- User ส่ง Requirement / Feature เข้ามาเพื่อให้แปลงเป็นการ์ดงานบน Trello

---

## 🧭 กระบวนการทำงาน (End-to-End Workflow)

```
User Requirement
       │
       ▼
[1. Codebase & GitHub Context Inspection]
    - ตรวจสอบ Codebase และ Schema จาก GitHub Repositories ของโปรเจกต์ `p8-altrarich` โดยตรง (เช่น `AD1-Copilot/p8-altrarich-backend`, `AD1-Copilot/p8-altrarich-frontend`, `AD1-Copilot/p8-altrarich-frontend-admin` บน branch `development`/`main`) ผ่าน gh CLI / GitHub API
    - ดึง Branch, Commit History ล่าสุด, DB Schema, API Specs และ Service Implementations เพื่อป้องกันการเดาโค้ดเอง
       │
       ▼
[2. SA Task Breakdown (/sa)]
    - วิเคราะห์ความจำเป็นจริงของขอบเขตงาน (Contextual Necessity): **ห้ามบังคับสร้างเป็นการ์ดคู่ [BE] + [FE] เสมอไป** ให้สร้างตามความจำเป็นจริงของงานเท่านั้น
      * หากเป็น **Backend-Only** (เช่น Internal logic, Gateway optimization, Cron job, DB migration ที่ API Contract ไม่เปลี่ยนและไม่กระทบ UI) ➡️ **สร้างเฉพาะ [BE] (+ [QA]) ห้ามสร้าง [FE] ให้รกบอร์ด**
      * หากเป็น **Frontend-Only** (เช่น UI redesign, Styling, Client-side validation) ➡️ **สร้างเฉพาะ [FE] (+ [QA]) ห้ามสร้าง [BE]**
      * สร้างเป็นคู่ **[BE] ⟷ [FE] เฉพาะเมื่อมีงานทั้งสองฝั่งจริง ๆ** (เช่น Feature ใหม่ที่มีทั้ง API ใหม่และ UI ใหม่, หรือมีการเปลี่ยน API Contract ที่กระทบ FE)
    - หากมีทั้ง [BE] และ [FE] ต้องแยกการ์ดกันชัดเจน (ห้ามรวมกันในการ์ดเดียว)
    - กำหนด Acceptance Criteria (AC) ไม่ต่ำกว่า 3 ข้อต่อ Task
    - กำหนด Endpoint, Payload, DB changes สำหรับ BE
    - กำหนด Component, UI States (Loading/Error/Success/Empty) สำหรับ FE
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
[4. User Review & Confirmation Gate (สำคัญมาก ⚠️)]
    - นำเสนอสรุปภาพรวม (Overview), การ์ด [BE], การ์ด [FE], AC Checklists, และ Custom Fields ให้ User ตรวจสอบ
    - รอให้ User ตอบ คอนเฟิร์ม/อนุมัติ (หรือสั่งปรับแก้) ก่อนยิง API สร้างการ์ดจริงลง Trello เสมอ
       │
       ▼
[5. Trello Automation Sync]
    - เมื่อ User คอนเฟิร์มแล้ว ยิง Trello REST API ผ่าน Engine ใน /Users/teerawat/tackingtask
    - สร้างการ์ดลงใน List เป้าหมาย (เช่น Sprint, Backlog)
    - ตั้งค่า Custom Fields: Est.(Days), Type, Priority
    - ใส่ Acceptance Criteria เป็น Checklist รายข้อ
       │
       ▼
[6. Agent Halo Real-time Broadcast]
    - ส่ง Event Lifecycle และ Trello Card URLs ไปยัง Agent Halo Dashboard/Overlay
       │
       ▼
[7. Cross-Link Paired Cards & Summary Report]
    - อัปเดต Description ข้ามลิงก์หากันระหว่างการ์ดคู่ [BE] ⟷ [FE] ⟷ [QA] (`🔗 Related Tasks / Paired Cards`)
    - สรุปผลให้ User พร้อม Direct Markdown Links สำหรับเปิดดูการ์ดบน Trello
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

## 📋 Trello Card Standards & Template

### ⚙️ [BE] Task Structure
- **Card Title:** `[BE] <Feature Name> API & Business Logic`
- **Card Description:** ต้องใส่ Task Specification ฉบับสมบูรณ์ใน Description เสมอ (Base URL, Request Headers, Endpoints & Methods, Webhook & Signature verification formula, Supported Events, Payload structure, DB changes) ห้ามย่อหรือตัดทิ้ง
- **Custom Fields:**
  - `Est.(Days)`: ตัวเลขประมาณการ (Number)
  - `Type`: `New` | `Improve` | `Fix`
  - `Priority`: `Highest` | `High` | `Medium` | `Low` | `Lowest`
- **Checklist:** Acceptance Criteria (AC) อย่างน้อย 3 ข้อ

### 🖥️ [FE] Task Structure
- **Card Title:** `[FE] <Feature Name> Screen & UI Integration`
- **Card Description:** ต้องระบุ Component Specs, Screens/Modals, API Integration endpoints, Design reference และ UI States ใน Description
- **Custom Fields:**
  - `Est.(Days)`: ตัวเลขประมาณการ (Number)
  - `Type`: `New` | `Improve` | `Fix`
  - `Priority`: `Highest` | `High` | `Medium` | `Low` | `Lowest`
- **Checklist:** Acceptance Criteria ครอบคลุม 4 UI States (Loading, Error, Success, Empty)

---

## 🛑 Critical Rules (กฎเหล็ก)

1. **Contextual Necessity & Strict Separation**: **ห้ามสร้างการ์ดเป็นคู่ [BE] + [FE] โดยไม่จำเป็นเด็ดขาด** ให้วิเคราะห์เนื้องานจริงก่อนเสมอ:
   - หากเป็นงาน **Backend-Only** (เช่น internal logic, gateway optimization, DB change ที่ API contract ไม่เปลี่ยนและไม่กระทบ UI) ➡️ **สร้างเฉพาะ `[BE]` (+ `[QA]`) ห้ามสร้าง `[FE]` เด็ดขาด**
   - หากเป็นงาน **Frontend-Only** (เช่น UI redesign, styling, client-side validation) ➡️ **สร้างเฉพาะ `[FE]` (+ `[QA]`) ห้ามสร้าง `[BE]` เด็ดขาด**
   - สร้างเป็นการ์ดคู่ `[BE] ⟷ [FE]` **เฉพาะเมื้องานนั้นต้องแก้โค้ดทั้งสองฝั่งจริง ๆ เท่านั้น** (และห้ามรวมไว้ในการ์ดเดียวกัน)
2. **Complete Card Description**: รายละเอียด Technical Specs, Endpoints, Headers, Webhook Events ทั้งหมดที่วิเคราะห์ได้ ต้องใส่ลงใน **Card Description** ของการ์ด Trello ให้ครบถ้วนสมบูรณ์ ห้ามตัดทอน
3. **Safe Shell / API Payload**: เมื่อส่ง Markdown Description ไปยัง Trello API ต้องระวัง Shell command injection / syntax expansion (หลีกเลี่ยงการส่ง backtick/quote ผ่าน bash ตรง ๆ หรือใช้ API Script โดยตรงเพื่อป้องกันข้อมูลหาย)
4. **Acceptance Criteria Mandatory**: ทุกการ์ดต้องมี Checklist ไม่น้อยกว่า 3 ข้อ
5. **No Guesswork & Mandatory GitHub Verification (p8-altrarich)**: ต้องตรวจสอบความถูกต้องของ Schema, Service Logic, Controller, และ Entity จาก **GitHub Codebase จริงของโปรเจกต์ `p8-altrarich`** (`AD1-Copilot/p8-altrarich-*` เช่น `p8-altrarich-backend`, `p8-altrarich-frontend` บน `development` branch) ผ่าน GitHub CLI / API เสมอ เพื่อให้มั่นใจว่าอ้างอิงจากโค้ดเวอร์ชันล่าสุดของทีม ไม่เดาเองเด็ดขาด
6. **User Confirmation Gate**: ต้องแสดงสรุป Spec & Tasks ให้ User ตรวจสอบและคอนเฟิร์มก่อนสร้างการ์ดจริงลง Trello ทุกครั้ง (ห้ามยิงสร้างทันทีโดย User ยังไม่เห็นชอบ)
7. **Agent Halo Synchronization**: ต้องส่งสัญญาณสถานะและ URL การ์ดให้ Agent Halo รับทราบทุกครั้ง
8. **Mandatory Native Card Attachment & Cross-Linking**: การ์ดงานที่เป็นคู่กันหรือเกี่ยวข้องกัน (เช่น `[BE]` กับ `[FE]`, `[BE]` กับ `[QA]`, หรือ Gateway Integration ครบชุด) จะต้องทำการ **ผูกการ์ดเข้าด้วยกันผ่าน Trello Native Card Attachment (แนบการ์ด Trello เข้าหากัน)** และใส่ Link URL ของการ์ดที่เกี่ยวข้อง (`🔗 Related Tasks / Paired Cards`) ใน Description ของกันและกันเสมอ ตามมาตรฐานของการ์ด #625 เพื่อให้ทีม Dev และ QA สามารถคลิกเปิดการ์ดคู่ที่แนบไว้ได้โดยตรงทันที


