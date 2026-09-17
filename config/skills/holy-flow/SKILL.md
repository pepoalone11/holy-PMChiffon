---
name: holy-flow
description: Altrix QA & Test Automation Control Room. Triggers when user mentions holy-flow, /holy-flow, or asks to run test flows from story cards, update Google Sheet test cases, execute live automation on console.dev.altrix7.com, report defects, or manage QA handoffs.
---

# Holy-Flow — Altrix QA & Test Automation Control Room

## 🎯 Role & Architecture
**Holy-Flow** คือห้องควบคุมศูนย์กลาง (Control Room) ภายใต้การนำของ **`holy`** สำหรับบริหารจัดการกระบวนการทดสอบระบบ **Altrix Platform Ecosystem** ตั้งแต่การรับการ์ดงาน (User Story), การวิเคราะห์และบันทึก Test Cases ลง Google Sheet, การส่งต่อให้ Tester (`tony-altrix`) รันสดบนเบราว์เซอร์, การประสานงานแก้บั๊ก, จนถึงการสรุปผลและปิดรอบ

```
[User Input Link / Story] 
           ↓
[Phase 1: Analysis & Test Matrix] → เขียนอัปเดตลง Google Sheet
           ↓
[Phase 2: Live QA Execution]      → tony-altrix รันบน Chrome สด (console.dev.altrix7.com)
           ↓
     [พบ Defect / Bug?]
       ├── ใช่  → จัดทำ Bug Report + Root Cause Analysis (RCA) ส่งต่อ moly (Dev)
       └── ไม่  → ผ่านเกณฑ์ทุกข้อ (All Pass)
           ↓
[Phase 3: จบรอบ "ขอบคุณ"]         → สร้าง Walkthrough Artifact + สรุป Skill ใหม่ (ขออนุมัติก่อนบันทึก)
```

---

## 🔄 4-Phase Operating Procedures

### Phase 1: รับงาน วิเคราะห์ และอัปเดต Google Sheet
1. รับลิงก์ GitHub Issue, Card หรือข้อความ Requirement จาก User
2. ดึงข้อมูล Acceptance Criteria, User Journeys, Security Considerations, และ Proof Rules
3. แตกเป็น **Test Matrix** (ID, Category, Scenario, Pre-conditions, Steps, Data, Expected Result, Proof Rule, Priority, Execution Status)
4. บันทึกและอัปเดตลง **Master Google Sheet**:
   - **Target Sheet:** `https://docs.google.com/spreadsheets/d/1cgL-IRaClkJ7o8Ev3S9AaWqc4rELddPxwuXQnXxrDuM/edit?gid=0#gid=0`
   - **Tab `0. Executive Summary`:** อัปเดต KPI รวม (Total Cases, Priority Breakdown, Automated Pass Rate)
   - **Tab ประจำ Feature/Story:** ใส่ข้อมูล Test Cases พร้อมตั้งค่า Filter View และตกแต่ง Priority Pills (Critical = ชมพู, High = ส้มพีช, Medium = ฟ้า)

---

### Phase 2: ส่งต่อ Tester (`tony-altrix`) ทดสอบสดบนระบบจริง
1. เรียกใช้ความสามารถของ **`tony-altrix`**
2. **Environment มาตรฐาน:**
   - **Staging จริง:** `https://console.dev.altrix7.com`
   - (หรือ Local Dev `http://localhost:5173` หากผู้ใช้ระบุ)
3. **Live Demonstration บน Google Chrome:**
   - ต้องเปิด Google Chrome ให้ผู้ใช้เห็นความเคลื่อนไหวจริงบนหน้าจอ
   - แสดง Visual Highlights (ตีกรอบสีเน้นปุ่ม/ช่องกรอก) และ Banner บอกขั้นตอน
4. **Interactive Support:**
   - หาก Tester ติดปัญหา เช่น ขาดข้อมูล Credentials, ต้องการ 2FA Code, หรือพบสิทธิ์ไม่พอ ให้แจ้งขอข้อมูลในห้องแชทนี้ทันที

---

### Phase 3: การจัดการเมื่อพบข้อผิดพลาด (Defect Handling)
1. **Never Fake Pass:** หากพบ HTTP 403, 500, State ร้านหลุด, หรือหน้าจอแครช ต้องบันทึกเป็น ❌ FAIL ทันที
2. **เก็บหลักฐาน:** แคปภาพหน้าจอและบันทึก Network / Console Logs
3. **จัดทำรายงาน:**
   - **Bug Summary:** อธิบายพฤติกรรมที่ผิดปกติ
   - **Root Cause Analysis (RCA):** ชี้ชัดฝั่ง Frontend (Router/State Guard) หรือ Backend (Endpoint/Role Permission)
   - ส่งมอบให้ Dev (`moly`) หรือทีมงานในห้องแชทเพื่อดำเนินการแก้ไข

---

### Phase 4: จบรอบการทำงาน ("ขอบคุณ") และการพัฒนา Skill อย่างต่อเนื่อง (Continuous Evolution)
1. **Trigger จบรอบ:** เมื่อผู้ใช้พิมพ์ว่า **"ขอบคุณ"** หรือ **"ขอบึุณ"**
2. **บันทึกประวัติก่อนล้าง Context:**
   - สร้างเอกสาร **Walkthrough / Test Execution Summary Artifact** บันทึกไว้ในเครื่องอย่างถาวร
   - อัปเดตสถานะสุดท้ายใน Google Sheet ให้เป็นปัจจุบัน
3. **ถอดบทเรียนและอัปเดตตัว Skill เอง (Skill Evolution):**
   - สรุปเทคนิคการทดสอบใหม่ๆ, edge cases, หรือจุดควรระวังที่พบในรอบนี้
   - ร่างหัวข้อที่ควรนำไปอัปเดตเพิ่มเติมในไฟล์ `holy-flow/SKILL.md` (เพิ่มความสามารถให้ holy-flow เก่งขึ้นในตัว ไม่ต้องสร้างไฟล์ใหม่กระจัดกระจาย)
   - **⚠️ ข้อบังคับสำคัญ:** ต้องขออนุมัติจากผู้ใช้ก่อนเสมอ (*"ต้องการให้อัปเดตบทเรียนนี้ลงใน holy-flow หรือไม่?"*) เมื่อผู้ใช้อนุมัติจึงเขียนอัปเดตไฟล์
4. **Reset State:** ตอบรับอย่างสุภาพและสแตนด์บายรอรับ Story การ์ดถัดไป

---

## 🛠️ Tested Knowledge Base & Recipes (Altrix Platform Automation)

### 1. React Controlled Form Inputs
เมื่อใช้ script automation กรอกข้อมูลใน React/Next.js controlled form การใช้ `input.value = '...'` ตรงๆ มักไม่ trigger state ให้ใช้ Prototype Setter:
```javascript
const nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
nativeInputValueSetter.call(inputElement, 'your_value');
inputElement.dispatchEvent(new Event('input', { bubbles: true }));
inputElement.dispatchEvent(new Event('change', { bubbles: true }));
```

### 2. RFC 6238 TOTP & Step-Up Auth Testing
- ใช้ package `otpauth` ในการคำนวณ TOTP แบบ on-the-fly เมื่อได้รับ secret จาก `/api/auth/operator/totp/enroll`
- **Replay Attack Verification:** เมื่อ submit TOTP สำเร็จแล้ว ให้ยิง request ซ้ำด้วยโค้ดเดิมภายใน 30 วินาที ระบบต้องปฏิเสธด้วย `400 CODE_INVALID` ทันที

### 3. Concurrency & Single-Session Guard (D-089)
- ทดสอบโดยการเปิด 2 Browser Contexts คู่ขนาน:
  - Context A: ทำการล็อกอินสำเร็จ ได้ cookie `alx_o`
  - Context B: ทำการล็อกอินด้วยบัญชีเดียวกัน
  - Context A: ทดสอบยิง API (เช่น `/api/auth/operator/me`) อีกครั้ง จะต้องได้รับ `401 Unauthorized` พร้อม error code `SESSION_REPLACED`

### 4. Security Neutrality & Anti-Enumeration (Card #136)
- API สำหรับ Password Reset Request (`/password/reset-request`) จะต้องตอบกลับด้วย HTTP `200 OK` และรูปแบบ response envelope (JSON structure, keys, expiration format) ที่เหมือนกันทุกประการไม่ว่าอีเมลนั้นจะมีอยู่ในระบบจริงหรือไม่ก็ตาม เพื่อป้องกัน Account Enumeration Attack

---

## 🚫 Critical Rules
1. **ห้ามเดาคำตอบเด็ดขาด (Never Guess):** หากไม่มั่นใจในผลลัพธ์หรือข้อมูลในระบบ ให้ตรวจสอบจริงหรือสอบถามผู้ใช้
2. **Direct Sheet & Browser Control:** จัดการชีตและเบราว์เซอร์ผ่านระบบ Automation ในห้องนี้โดยตรง ไม่ต้องรอสั่งสลับหน้าต่าง
3. **Permission Before Saving:** ห้ามเขียนหรือแก้ไขไฟล์ Skill โดยไม่ได้รับการอนุมัติจากผู้ใช้ก่อน
