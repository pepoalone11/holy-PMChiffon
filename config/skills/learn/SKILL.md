---
name: learn
description: Explore a codebase with parallel agents — clone, read, analyze, and document. Modes — --fast (1 agent), default (3 agents), --deep (5 agents). Trigger when user says "learn [repo]", "explore codebase", "study this repo", "/learn [url|path]", or shares a GitHub repository URL to analyze.
---

# /learn — Codebase Deep Dive Learning Skill

สำรวจ วิเคราะห์ และสร้างเอกสารสรุป Codebase อย่างเป็นระบบ ด้วยการรัน Parallel Subagents ตามระดับความลึกที่เลือก

---

## 🎯 Triggers
เริ่มทำงานเมื่อ:
- User พิมพ์ `/learn [url|path]`
- User สั่งให้ "learn [repo]", "แกะ repo", "ศึกษา codebase นี้", "explore codebase" หรือแชร์ GitHub URL

---

## 🧭 Depth Modes (ระดับความลึกในการสำรวจ)

| Flag | Agents | Output Files | Use Case |
|---|:---:|---|---|
| `--fast` | 1 | `[TIME]_OVERVIEW.md` | สแกนเร็ว สรุปภาพรวมและวิธีใช้งานเบื้องต้น (~1-2 นาที) |
| *(default)* | 3 | `ARCHITECTURE.md`, `CODE-SNIPPETS.md`, `QUICK-REFERENCE.md` | สำรวจมาตรฐาน เข้าใจสถาปัตยกรรมและโค้ดหลัก (~3-5 นาที) |
| `--deep` | 5 | เพิ่ม `TESTING.md`, `API-SURFACE.md` | เจาะลึกครบวงจรสำหรับ Codebase ขนาดใหญ่หรือซับซ้อน |

```bash
/learn --fast [target]   # สแกนเร็ว (1 agent)
/learn [target]          # สำรวจมาตรฐาน (3 agents)
/learn --deep [target]   # เจาะลึกทุกแง่มุม (5 agents)
```

---

## 📂 โครงสร้างการจัดเก็บเอกสาร (.agent-state/learn/)

```
.agent-state/
└── learn/
    ├── .origins             # รายการ repository ทั้งหมดที่เคย learn
    └── <owner>/
        └── <repo>/
            ├── origin       # Source code หรือ Symlink ไปยัง source
            ├── repo.md      # Hub file สรุปภาพรวมและ Link ไปยังทุก session
            └── YYYY-MM-DD/  # โฟลเดอร์วันที่
                ├── HHMM_ARCHITECTURE.md
                ├── HHMM_CODE-SNIPPETS.md
                ├── HHMM_QUICK-REFERENCE.md
                ├── HHMM_TESTING.md
                └── HHMM_API-SURFACE.md
```

---

## 🚀 กระบวนการทำงาน (Execution Steps)

### Step 0: เตรียม Repository และ Path (CRITICAL)

1. กำหนด Root Directory:
```bash
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AGENT_STATE_DIR="${AGENT_STATE_DIR:-$REPO_ROOT/.agent-state}"
```

2. หาก Target เป็น URL (GitHub / Git):
   - ตรวจสอบว่ามี `ghq` หรือใช้ `git clone` ปกติ
   - ทำการ clone ลงปลายทาง หรือ symlink มาที่ `$AGENT_STATE_DIR/learn/<owner>/<repo>/origin`
   - บันทึกชื่อ `<owner>/<repo>` ลง `$AGENT_STATE_DIR/learn/.origins`

3. คำนวณ Absolute Paths ชัดเจน:
   - `TODAY`: `YYYY-MM-DD` (เช่น `2026-08-19`)
   - `TIME`: `HHMM` (เช่น `1130`)
   - `SOURCE_DIR`: `$AGENT_STATE_DIR/learn/<owner>/<repo>/origin/` (หรือ Absolute Path ของโปรเจกต์ต้นทาง)
   - `DOCS_DIR`: `$AGENT_STATE_DIR/learn/<owner>/<repo>/<TODAY>/`

4. สร้างไดเรกทอรีจัดเก็บเอกสารก่อนเริ่มรัน:
```bash
mkdir -p "$DOCS_DIR"
```

> ⚠️ **CRITICAL RULE FOR AGENTS / SUBAGENTS**:
> ต้องระบุพาธแบบ **Literal Absolute Path** ให้ Subagents ชัดเจนเสมอ:
> - **READ from**: `[SOURCE_DIR]` (โฟลเดอร์อ่านโค้ด)
> - **WRITE to**: `[DOCS_DIR]/[TIME]_[FILENAME].md` (โฟลเดอร์เขียนเอกสาร ห้ามเขียนลงใน `origin/`)

---

### Step 1: รันการวิเคราะห์ตาม Mode

#### ⚡ Mode: `--fast` (1 Agent)
ส่ง Subagent ทำงานเดี่ยว:
- **Output**: `[DOCS_DIR]/[TIME]_OVERVIEW.md`
- **ขอบเขตการวิเคราะห์**:
  1. ภาพรวมโปรเจกต์ (What is this project?)
  2. ไฟล์สำคัญที่เป็น Core / Entry point
  3. วิธีการติดตั้งและเริ่มต้นใช้งานเบื้องต้น (Install & Quickstart)
  4. Tech stack, Libraries และ Patterns เด่นๆ

---

#### 🔍 Mode: Default (3 Parallel Subagents)
เรียกใช้งาน 3 Subagents พร้อมกัน:

1. **Architecture Explorer** → `[TIME]_ARCHITECTURE.md`
   - Directory Structure & High-level Design
   - Entry points ทั้งหมดและการไหลของข้อมูล (Data flow)
   - Core Abstractions, Modules และ Interfaces
   - Dependency Mapping

2. **Code Snippets Collector** → `[TIME]_CODE-SNIPPETS.md`
   - Key Entry point code implementations
   - ตัวอย่างโค้ดฟังก์ชันหลักและ Logic สำคัญ
   - Idioms & Design Patterns ที่น่าสนใจ พร้อมคำอธิบาย
   - Error handling & State management strategies

3. **Quick Reference Builder** → `[TIME]_QUICK-REFERENCE.md`
   - สรุปความสามารถหลัก (Feature checklist)
   - คู่มือการติดตั้ง Configuration และ Environment Variables
   - Cheat Sheet วิธีเรียกใช้งานคำสั่ง/API สำคัญ
   - Common Use Cases & Examples

---

#### 🔬 Mode: `--deep` (5 Parallel Subagents)
รัน 3 ตัวข้างต้น พร้อมเพิ่มอีก 2 Subagents:

4. **Testing & Quality Patterns** → `[TIME]_TESTING.md`
   - Testing structure & Frameworks (Unit, Integration, E2E)
   - Mocking strategies และ Test utilities
   - Code quality, Linter, CI/CD pipelines & Coverage

5. **API & Integration Surface** → `[TIME]_API-SURFACE.md`
   - Public API Reference & Endpoints / SDK methods
   - Extension points, Hooks, Event listeners, Plugins
   - Integration patterns & Authentication flow

---

### Step 2: สร้างและอัปเดตไฟล์ Hub กลาง (`repo.md`)

สร้างหรืออัปเดตไฟล์ `$AGENT_STATE_DIR/learn/<owner>/<repo>/repo.md` เพื่อรวบรวมทุกรอบการศึกษา:

```markdown
# [REPO] Learning Index

## Source
- **Origin Path**: ./origin/
- **GitHub**: https://github.com/<owner>/<repo>

## Explorations History

### 📅 [TODAY] [TIME] (Mode: [fast|default|deep])
- 🏛️ [[YYYY-MM-DD/HHMM_ARCHITECTURE|Architecture]]
- 💻 [[YYYY-MM-DD/HHMM_CODE-SNIPPETS|Code Snippets]]
- 📖 [[YYYY-MM-DD/HHMM_QUICK-REFERENCE|Quick Reference]]
- 🧪 [[YYYY-MM-DD/HHMM_TESTING|Testing Patterns]] *(ถ้ามี)*
- 🔌 [[YYYY-MM-DD/HHMM_API-SURFACE|API Surface]] *(ถ้ามี)*

**Key Insights & Takeaways**:
- [สรุปสิ่งที่ได้เรียนรู้ 2-3 ข้อ]
```

---

### Step 3: สรุปผลลัพธ์ให้ User ทราบ

แสดงตารางสรุปผลลัพธ์ ไฟล์ที่สร้างขึ้นทั้งหมด และ Key Insights สั้นๆ ให้ผู้ใช้พร้อมใช้งานได้ทันที

---

## 🔒 Safety & Boundary Rules
- **Read-Only Access บน Source Code**: อ่านและวิเคราะห์โค้ดเท่านั้น ห้ามแก้ไขไฟล์ใดๆ ใน source/origin
- **Strict Isolation**: ไฟล์เอกสารผลลัพธ์ทั้งหมดต้องเขียนลงใน `.agent-state/learn/...` เท่านั้น
