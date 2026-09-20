---
name: fa-expense-record
description: "FlowAccount บันทึกชำระเงินค่าใช้จ่าย (FA-บันทึกค่าใช้จ่าย). ดำเนินการตรวจสอบบิล SPX Express/ใบเสร็จ คัดกรอง Username/Seller ID (sahatool -> SAHATOOLS. (Shopee), anucha070838 -> AB (Shopee)) และบันทึกชำระเงินอัตโนมัติบน FlowAccount พร้อม On-Screen Alert. Triggers on FA-บันทึกค่าใช้จ่าย, /fa-expense, บันทึกค่าใช้จ่าย, หรือ flowaccount ค่าใช้จ่าย."
---

# FA-บันทึกค่าใช้จ่าย — FlowAccount Expense Payment Automation

## 🎯 ภาพรวมและหน้าที่ (Overview & Objective)
Skill นี้ถูกออกแบบมาสำหรับระบบ **FlowAccount Advance** เพื่อจัดการและบันทึกชำระเงินเอกสารค่าใช้จ่าย (**Expenses**) ที่ผ่านการ **"อนุมัติ"** แล้ว โดยตรวจสอบความถูกต้องของใบเสร็จแนบ (Receipt Attachment) ก่อนบันทึกชำระเงินเสมอ เพื่อความแม่นยำทางบัญชีและการเงินสูงสุด 100%

---

## 🔒 กฎเหล็กด้านความปลอดภัยและการเงิน (Strict Financial Safety Rules)
1. **ห้ามเดาคำตอบเด็ดขาด (Zero Guessing Rule)**:
   - หากตรวจไม่พบข้อมูล หรือไม่มั่นใจในตัวเลข/Username **ห้ามทำการบันทึกชำระเงินเด็ดขาด**
   - ตอบตามตรงว่าไม่รู้ และหยุดเพื่อสอบถามผู้ใช้
2. **เงื่อนไขหยุดการทำงานฉุกเฉิน (Emergency Stop)**:
   - ตรวจพบ Username อื่นที่ **ไม่อยู่ใน Mapping Table** ➔ **หยุดทำงานทันที**
   - ไม่มีรูปใบเสร็จแนบในระบบ (Empty Thumbnail / No Attachment) ➔ **หยุดทำงานทันที** หรือข้ามรายการนั้นและแจ้งเตือน
   - รูปภาพเสียหาย โหลดไม่ขึ้น หรือตัวอักษรเบลอจน OCR อ่าน Username ไม่ได้ ➔ **หยุดทำงานทันที**
3. **การแสดงสถานะสดบนหน้าจอ (Live On-Screen Alert Banner)**:
   - ทุกครั้งที่เริ่มประมวลผล ต้องแสดง Alert Banner สีฟ้า บนหน้าจอจริงของผู้ใช้
   - เมื่อบันทึกสำเร็จ ต้องแสดง Alert Banner สีเขียว
   - เมื่อตรวจพบความผิดปกติหรือหยุด ต้องแสดง Alert Banner สีแดง

---

## 📋 ตารางคู่บัญชีชำระเงิน (Account & Channel Mapping Table)

| Username ในบิล | Seller ID ในบิล | ประเภทใบเสร็จ | ช่องทางชำระเงิน (Dropdown 1) | ประเภท (Dropdown 2) | ช่องทางชำระ (Dropdown 3) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`sahatool`** | `1251449255` | SPX Express / Shopee | **ช่องทางอื่นๆ** | **ร้านค้าออนไลน์ (Online shop/E-Commerce)** | **`SAHATOOLS. (Shopee)`** |
| **`anucha070838`** | `31650165` | SPX Express / Shopee | **ช่องทางอื่นๆ** | **ร้านค้าออนไลน์ (Online shop/E-Commerce)** | **`AB (Shopee)`** |
| *อื่นๆ หรือไม่พบบิล* | *ไม่ตรง* | - | 🛑 **ห้ามบันทึก** | 🛑 **หยุดทำงานทันที** | 🛑 **แจ้งผู้ใช้เพื่อขอคำยืนยัน** |

---

## 🔄 ลำดับขั้นตอนการทำงาน (End-to-End Workflow)

```
[เปิดหน้ารายการค่าใช้จ่าย FlowAccount]
                 ↓
[กรองสถานะ: "อนุมัติ" & ขยายการแสดงผลเป็น 100 รายการ]
                 ↓
[ดึง URL รูปภาพใบเสร็จจากแถวตาราง (.img-position img)]
                 ↓
[ดาวน์โหลดภาพ & รัน OCR (Tesseract / Text Inspection)]
                 ↓
     [ตรวจสอบ Username & Seller ID]
        ├── เป็น `sahatool`      ➔ กำหนด Channel = `SAHATOOLS. (Shopee)`
        ├── เป็น `anucha070838`  ➔ กำหนด Channel = `AB (Shopee)`
        └── ไม่พบ / เป็นชื่ออื่น  ➔ 🛑 หยุดทำงานทันที + ขึ้น Alert สีแดง + แจ้งผู้ใช้
                 ↓
[สรุปยอดเงินและรายการให้ผู้ใช้ตรวจสอบ (รอบละ 5-10 รายการ)]
                 ↓
[ได้รับคำยืนยันจากผู้ใช้ ➔ ดำเนินการบันทึกชำระเงินบน FlowAccount]
        ├── 1. แสดง Alert สีฟ้า: "กำลังบันทึกชำระเงิน EXPxxxxxx..."
        ├── 2. กด Action Dropdown ➔ ชำระเงิน (receiptPayment)
        ├── 3. ตรวจสอบ Modal ตรงกับเลขที่เอกสาร
        ├── 4. เลือก: ช่องทางอื่นๆ ➔ ร้านค้าออนไลน์ ➔ ช่องทางตาม Mapping
        ├── 5. กดปุ่มบันทึก (#add-payment-btn)
        └── 6. แสดง Alert สีเขียว: "✅ บันทึกสำเร็จ"
                 ↓
[หน่วงเวลา Human Pacing 1.5 - 2 วินาที ป้องกัน Rate Limit]
```

---

## 💻 ชุดสคริปต์อัตโนมัติ (Automation Scripts Reference)

### 1. Alert Banner Helper (`window.showAutoAlert`)
```javascript
window.showAutoAlert = function(msg, color = '#2196F3') {
  let box = document.getElementById('auto-alert-box');
  if (!box) {
    box = document.createElement('div');
    box.id = 'auto-alert-box';
    box.style.cssText = 'position:fixed; top:20px; left:50%; transform:translateX(-50%); z-index:999999; padding:12px 24px; border-radius:8px; font-weight:bold; font-size:16px; color:#fff; box-shadow:0 4px 12px rgba(0,0,0,0.3); transition:all 0.3s ease; pointer-events:none; font-family:sans-serif;';
    document.body.appendChild(box);
  }
  box.innerText = msg;
  box.style.backgroundColor = color;
  box.style.display = 'block'; if (autoDismiss && !msg.startsWith('🛑')) setTimeout(() => { box.style.display = 'none'; }, 4000);
};
```

### 2. OCR Verification via Shell
```bash
# ตรวจสอบภาพบิล SPX Express
/opt/homebrew/bin/tesseract "$IMAGE_PATH" stdout --psm 6 2>/dev/null | grep -iE 'sahatool|anucha|user|seller'
```

### 3. Payment Processing Function (`window.processExpensePayment`)
```javascript
window.processExpensePayment = async function(expectedSerial, channelName) {
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  
  // 1. Find Table Row
  const rows = Array.from(document.querySelectorAll('datatable-body-row'));
  const row = rows.find(r => r.innerText.includes(expectedSerial));
  if (!row) return { success: false, error: 'Row not found: ' + expectedSerial };
  
  // Alert
  if (window.showAutoAlert) {
    window.showAutoAlert('กำลังบันทึกชำระเงิน ' + expectedSerial + ' (' + channelName + ')...', '#2196F3');
  }
  
  // 2. Open Dropdown
  const arrow = row.querySelector('[data-test="action-dropdown-arrow"]') || row.querySelector('.dropdown-toggle');
  if (!arrow) return { success: false, error: 'Dropdown arrow not found' };
  arrow.click();
  await sleep(400);
  
  // 3. Click receiptPayment
  const payOption = row.querySelector('[data-testid="receiptPayment"]') ||
                    Array.from(document.querySelectorAll('.dropdown-menu.show li, .status-dropdown-menu li'))
                         .find(el => el.innerText && el.innerText.includes('ชำระเงิน'));
  if (!payOption) return { success: false, error: 'receiptPayment option not found' };
  payOption.click();
  await sleep(1500);
  
  // 4. Verify Modal
  const modal = document.querySelector('.payment-modal.show') || document.querySelector('.payment-modal');
  if (!modal) return { success: false, error: 'Payment modal not found' };
  if (!modal.innerText.includes(expectedSerial)) {
    return { success: false, error: 'Modal serial mismatch: ' + expectedSerial };
  }
  
  // 5. Select "ช่องทางอื่นๆ"
  const dd0 = modal.querySelector('.mpc-row__method');
  if (!dd0 || !dd0.shadowRoot) return { success: false, error: 'dd0 method shadowRoot missing' };
  const trig0 = dd0.shadowRoot.querySelector('.p-dropdown-trigger') || dd0.shadowRoot.querySelector('.p-dropdown');
  trig0.click();
  await sleep(400);
  const item0 = Array.from(dd0.shadowRoot.querySelectorAll('.p-dropdown-item, li')).find(el => el.innerText && el.innerText.includes('ช่องทางอื่นๆ'));
  if (!item0) return { success: false, error: 'ช่องทางอื่นๆ not found' };
  item0.click();
  await sleep(700);
  
  // 6. Select "ร้านค้าออนไลน์ (Online shop/E-Commerce)"
  const mpcHeader = modal.querySelector('.mpc-row__header');
  const mpcRow = mpcHeader.parentElement;
  let dropdowns = Array.from(mpcRow.querySelectorAll('flowaccount-fa-dropdown'));
  const dd1 = dropdowns[1];
  if (!dd1 || !dd1.shadowRoot) return { success: false, error: 'dd1 type shadowRoot missing' };
  const trig1 = dd1.shadowRoot.querySelector('.p-dropdown-trigger') || dd1.shadowRoot.querySelector('.p-dropdown');
  trig1.click();
  await sleep(400);
  const item1 = Array.from(dd1.shadowRoot.querySelectorAll('.p-dropdown-item, li')).find(el => el.innerText && el.innerText.includes('ร้านค้าออนไลน์'));
  if (!item1) return { success: false, error: 'ร้านค้าออนไลน์ not found' };
  item1.click();
  await sleep(700);
  
  // 7. Select Target Channel (e.g. 'SAHATOOLS. (Shopee)' or 'AB (Shopee)')
  dropdowns = Array.from(mpcRow.querySelectorAll('flowaccount-fa-dropdown'));
  const dd2 = dropdowns[2];
  if (!dd2 || !dd2.shadowRoot) return { success: false, error: 'dd2 channel shadowRoot missing' };
  const trig2 = dd2.shadowRoot.querySelector('.p-dropdown-trigger') || dd2.shadowRoot.querySelector('.p-dropdown');
  trig2.click();
  await sleep(400);
  const item2 = Array.from(dd2.shadowRoot.querySelectorAll('.p-dropdown-item, li')).find(el => el.innerText && el.innerText.includes(channelName));
  if (!item2) return { success: false, error: 'Channel ' + channelName + ' not found' };
  item2.click();
  await sleep(600);
  
  // 8. Click Save Button
  const saveBtn = document.querySelector('#add-payment-btn');
  if (!saveBtn) return { success: false, error: '#add-payment-btn not found' };
  saveBtn.click();
  
  // 9. Wait for completion
  await sleep(2000);
  if (window.showAutoAlert) {
    window.showAutoAlert('✅ บันทึกชำระเงิน ' + expectedSerial + ' สำเร็จแล้ว', '#4CAF50');
  }
  return { success: true, serial: expectedSerial };
};
```

---

## ⚠️ แนวทางการจัดการข้อผิดพลาด (Troubleshooting & Exceptions)
- **Modal ซ้อนหรือไม่ปิด**: ตรวจสอบ `.payment-modal.show` และหากเกิด error ให้คลิกปุ่มปิด `.close` หรือ `[data-dismiss="modal"]` เพื่อไม่ให้บล็อกการทำงานรอบถัดไป
- **ตารางเลื่อน / Re-render**: ตรวจสอบ Serial Number ใน `datatable-body-row` ทุกครั้งก่อนคลิก ห้ามคลิกตาม row index เด็ดขาด เพราะข้อมูลเลื่อนตำแหน่งได้เมื่อมีรายการถูกบันทึกสำเร็จ
- **Rate Limit**: หาก FlowAccount แสดง spinner โหลดช้า ให้เพิ่มเวลา sleep ระหว่างขั้นตอนเป็น 2.5 - 3 วินาที
