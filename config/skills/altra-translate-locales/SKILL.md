---
name: altra-translate-locales
description: Fill empty msgstr entries across all 5 AltraRich .po catalogs, compile catalogs, and verify missing count is 0. Trigger on /altra-translate-locales, altra-translate, หรือ "แปลภาษา altrarich / แปล locales".
---

# Altra Translate Locales — AltraRich i18n & Translation Sync

Manages and verifies Lingui localization catalogs (`.po` files) across 5 supported languages in AltraRich.

## 🎯 Scope & Triggers
Trigger when:
- User asks `/altra-translate-locales`, `altra-translate`, หรือ "แปลภาษา altrarich / แปล locales"
- New UI strings or keys are added that require catalog synchronization.

Target Directory:
`src/locales/` (in Theme or Console repos).

---

## 🛠️ Step-by-Step Procedure

### 1. Extract Current Keys
Run extract in the repo root:
```bash
pnpm lingui extract
```
*(Avoid `--clean` unless intentionally pruning dead keys, because bare strings in constants might get erased).*

### 2. Identify Missing Translations
Search for empty `msgstr ""` entries in:
- `src/locales/th/messages.po` (Thai)
- `src/locales/en/messages.po` (English)
- `src/locales/zh/messages.po` (Chinese)
- and other active locales.

### 3. Translate & Fill Catalogs
- Maintain context-appropriate iGaming & financial terminology (e.g., ยอดเทิร์นโอเวอร์, ฝาก-ถอน, ประวัติการเล่น).
- Retain all placeholders (e.g., `{0}`, `{name}`, `{amount}`) exactly as in `msgid`.

### 4. Compile & Verify
Run compilation:
```bash
pnpm lingui
```
Verify that the output concludes with **missing count: 0** for all language catalogs.
