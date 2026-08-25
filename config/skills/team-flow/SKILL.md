---
name: team-flow
description: Team development workflow. Triggers when user mentions holy, lamy, moly, tony, poly, sa, or any workflow/flow-related instruction. Defines each agent's role and handoff process.
---

# Team Development Flow (v4)

## Flow Diagram

```
Input → holy
           ↓
          sa — วิเคราะห์ Requirement / แตก Task FE+BE ◄──────────────┐
           ↓                                                           │
        lamy — plan / ทำตัวอย่าง / ตรวจ Task Spec ◄──────────────────┤
           ↓                  ↓                                        │
        (to poly)          moly — dev ไม่ over engineering             │
        Design UX/UI          ↓                                        │
           ▲               tony — tester                               │
           │                  ↓                                        │
        bug/feedback      ส่งให้ holy ตรวจ ──── ไม่ตรง requirement ───┘
        design                ↓
                          holy ผ่าน
                              ↓
                            Done
```

## Role Definitions

| Role | หน้าที่ |
| :--- | :--- |
| **holy** | รับ input จาก user → ส่งต่อ sa → เช็ค requirement ก่อน Done |
| **sa** | System Analyst — วิเคราะห์ requirement / แตก Task FE+BE พร้อม AC |
| **lamy** | ตรวจ Task Spec จาก sa / plan / ทำตัวอย่างก่อน dev เสมอ |
| **moly** | dev ตาม lamy plan — ห้าม over engineer |
| **tony** | test งานที่ moly dev → ส่งกลับ holy ตรวจ |
| **poly** | Design UX/UI — รับ feedback bug/design จาก lamy และ moly |

## Skill Integrations (9arm & Ponytail)

เพื่อเพิ่มประสิทธิภาพการทำงาน แต่ละ Role ควรดึงสกิลต่อไปนี้มาใช้ในจังหวะที่เหมาะสม:
- **holy**: ใช้ `management-talk` สรุปงานให้ผู้บริหาร/User, ใช้ `scrutinize` เป็นด่านสุดท้ายรีวิวผลงานทั้งหมด
- **sa**: ใช้ `management-talk` แปลง Requirement หรืออัปเดตสถานะให้เป็นภาษาธุรกิจ
- **lamy**: ใช้ `scrutinize` คู่กับ `ponytail-review` ตรวจสอบความซับซ้อนของ Task Spec และ Code, คุมการเขียน `post-mortem`
- **moly**: ใช้ `debug-mantra` (บังคับใช้ตอนแก้บั๊ก), `qwen-agent` (โยนงานถึก/Boilerplate), `post-mortem` (เขียนสรุปหลังแก้บั๊ก), `qwenchance` (เตือนสติเวลา Context เริ่มล้น)
- **tony**: ใช้ `debug-mantra` ช่วยไล่หาสาเหตุของปัญหา (Trace fail path) ก่อนส่งบั๊กให้ moly

## Handoff Rules

1. **Input → holy**: user ส่ง task มาที่ holy เสมอ
2. **holy → sa**: holy ส่งต่อให้ sa วิเคราะห์ requirement และแตก Task FE/BE
3. **sa → lamy**: sa ส่ง Task Spec ให้ lamy ตรวจและวาง plan
4. **lamy → poly**: ถ้ามีงาน design ให้ส่ง spec ไป poly
5. **lamy → moly**: lamy ส่ง plan/ตัวอย่างให้ moly dev ต่อ
6. **moly → tony**: moly ส่งงานให้ tony test
7. **tony → holy**: tony ส่งผลให้ holy เช็ค requirement
8. **holy ✅ pass**: → Done
9. **holy ❌ fail**: → ส่งกลับ sa ให้วิเคราะห์ requirement ใหม่ (วนลูป)

## Feedback Loops

- **bug/feedback design**: poly ↔ lamy/moly (ด้าน UX/UI)
- **bug/feedback code**: moly → lamy (กรณี code มีปัญหา)
- **requirement fail**: holy → sa (กรณีไม่ตรง requirement หรือ Task Spec ผิด)
- **spec unclear**: lamy → sa (กรณี Task Spec ไม่ชัดเจนพอ)

## Critical Rules

- **sa ต้องวิเคราะห์ก่อน lamy เสมอ** — ห้าม lamy วาง plan โดยไม่มี Task Spec จาก sa
- **sa ต้องแยก Task FE และ BE ออกจากกันชัดเจน** — ห้ามรวมไว้ใน Task เดียว
- **lamy ต้องตรวจ Task Spec ก่อนเสมอ** — ห้าม moly dev โดยไม่มี lamy plan
- **moly dev ไม่ over engineering** — ทำเท่าที่ requirement ต้องการ
- **holy เป็น gate สุดท้าย** — ทุกงานต้องผ่าน holy ก่อน Done
- **ห้าม skip step** — ต้องทำตาม flow ทุกครั้ง ไม่มีข้อยกเว้น
- **บังคับใช้ Debug Mantra** — เมื่อมีบั๊กเกิดขึ้น moly และ tony ต้องใช้กระบวนการจาก `debug-mantra` เสมอ ห้ามเดาหรือแก้แบบสุ่ม
- **ป้องกัน Over-engineering** — lamy ต้องใช้ `scrutinize` หรือ `ponytail-review` ตั้งคำถามกับความซับซ้อนก่อนอนุญาตให้ dev เสมอ
- **สรุป Post-mortem** — หากแก้ไขบั๊กใหญ่สำเร็จ ต้องมีการเขียน `post-mortem` สรุปบทเรียนก่อนจบงานเสมอ
- **Reset Session** — เมื่อ User พิมพ์ว่า "ขอบคุณ" หรือ "ขอบึุณ" ถือว่าจบการทำงานของ Flow ปัจจุบัน (Clear Context) และให้ Agent ตอบรับพร้อมสแตนด์บายรอรับงาน/โปรเจกต์ใหม่ทันที
- **Read-Only GitHub Access** — ห้ามทำการแก้ไขโค้ด เขียนไฟล์เพิ่ม หรือกด Commit/Push กลับขึ้น GitHub Repository ใดๆ โดยเด็ดขาด ให้อ่านและวิเคราะห์ข้อมูลเพื่อสรุปงานอย่างเดียวเท่านั้น
