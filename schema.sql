-- ฐานข้อมูล D1 ของตารางงานรายเดือน (รันซ้ำได้ ไม่ลบข้อมูลเดิม)
CREATE TABLE IF NOT EXISTS events (
  id         TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  date       TEXT NOT NULL,              -- YYYY-MM-DD
  time       TEXT NOT NULL DEFAULT '',
  place      TEXT NOT NULL DEFAULT '',
  detail     TEXT NOT NULL DEFAULT '',
  menu       TEXT NOT NULL DEFAULT '',
  guests     TEXT NOT NULL DEFAULT '',
  leader     TEXT NOT NULL DEFAULT '',
  type       INTEGER NOT NULL DEFAULT 0, -- ลำดับของหมวดงานใน meta.cats
  updated_at INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_events_date ON events(date);

-- เก็บค่าทั่วไป: rev = เลขเวอร์ชันข้อมูล (เพิ่มทุกครั้งที่แก้), cats = รายชื่อหมวดงาน (JSON)
CREATE TABLE IF NOT EXISTS meta (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
INSERT OR IGNORE INTO meta(key, value) VALUES ('rev', '0');

-- กันเดารหัสผ่าน: บันทึกการล็อกอินที่ผิดตาม IP
CREATE TABLE IF NOT EXISTS login_fail (
  ip TEXT NOT NULL,
  at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_login_fail ON login_fail(ip, at);
