# ตารางงานรายเดือน — Cloudflare Pages + D1

หน้าเว็บอยู่บน Cloudflare Pages ข้อมูลอยู่ในฐานข้อมูล D1 เข้าใช้งานด้วยรหัสผ่านเดียว (ทุกเครื่องเห็นข้อมูลชุดเดียวกัน ซิงก์ทุก ~20 วินาที)

## Deploy (ทำครั้งเดียว ใช้เวลาราว 10 นาที)

ต้องมี Node.js 18 ขึ้นไป และบัญชี Cloudflare (แพลนฟรีพอ)

```bash
npm install
npx wrangler login

# 1) สร้างฐานข้อมูล แล้วคัดลอก database_id ไปใส่ใน wrangler.toml
npx wrangler d1 create schedule-db

# 2) สร้างตารางในฐานข้อมูลจริง
npm run db:init

# 3) สร้างโปรเจกต์ Pages
npx wrangler pages project create schedule --production-branch=main

# 4) ตั้งรหัสผ่านและกุญแจลับ (พิมพ์ค่าเมื่อโปรแกรมถาม)
npx wrangler pages secret put APP_PASSWORD   --project-name schedule   # รหัสผ่านที่ทุกคนใช้เข้าระบบ
npx wrangler pages secret put SESSION_SECRET --project-name schedule   # ข้อความสุ่มยาว ๆ เช่น ผลจาก: openssl rand -hex 32

# 5) ขึ้นเว็บ
npm run deploy
```

เสร็จแล้วจะได้ลิงก์ `https://schedule.pages.dev` (หรือชื่อที่คุณตั้ง) เพิ่มโดเมนของตัวเองได้ที่ Dashboard > Workers & Pages > schedule > Custom domains

## ย้ายข้อมูลเดิมมาใส่ระบบใหม่

ข้อมูลเดิมเก็บอยู่ในเบราว์เซอร์ของเว็บเดิม จึงต้องย้ายด้วยไฟล์สำรอง
1. เปิดเว็บเดิม กด **💾 สำรอง** เก็บไฟล์ .xlsx
2. เปิดเว็บใหม่ ล็อกอิน กด **📂 กู้คืน** เลือกไฟล์นั้น แล้วยืนยัน

## หมายเหตุ

- เปลี่ยนรหัสผ่าน: รัน `secret put APP_PASSWORD` ใหม่ แล้ว `npm run deploy` อีกครั้ง ทุกเครื่องจะต้องล็อกอินใหม่
- ล็อกอินผิดเกิน 5 ครั้งใน 10 นาที (จาก IP เดียวกัน) จะถูกพักชั่วคราว
- สำรองฐานข้อมูลทั้งก้อน: `npx wrangler d1 export schedule-db --remote --output=backup.sql`
- ทุกครั้งที่แก้ไฟล์ใน public/ ให้เปลี่ยนเลข `CACHE` ใน public/sw.js เพื่อให้เครื่องผู้ใช้โหลดของใหม่
- ทดลองในเครื่อง: คัดลอก `.dev.vars.example` เป็น `.dev.vars` > `npm run db:init:local` > `npm run dev`
- ถ้าเปิดไฟล์ index.html ตรง ๆ โดยไม่มีหลังบ้าน แอปจะเก็บข้อมูลในเครื่องเหมือนเดิม
