# ระบบจัดการสินค้า (Product Management System) (Offline)

ระบบจัดการสินค้าประกอบด้วยแอปพลิเคชัน Flutter สำหรับอุปกรณ์มือถือ และ API ที่พัฒนาด้วย FastAPI สำหรับการจัดการข้อมูลสินค้า

## รายละเอียดโครงการ

ระบบนี้พัฒนาขึ้นเพื่อจัดการข้อมูลสินค้า โดยมีความสามารถในการเพิ่ม, แก้ไข, ลบ และแสดงข้อมูลสินค้า พร้อมทั้งมีระบบการยืนยันตัวตนด้วยชีวมิติเพื่อเพิ่มความปลอดภัยในการลบข้อมูล

## โครงสร้างโปรเจค

```
project/
├── flutter_app/
│   ├── lib/
│   │   ├── main.dart            # จุดเริ่มต้นของแอปพลิเคชัน
│   │   ├── main_screen.dart     # หน้าจอหลักสำหรับแสดงและจัดการสินค้า
│   │   ├── notify.dart          # คลาสสำหรับจัดการการแจ้งเตือน
│   │   └── product_model.dart   # โมเดลข้อมูลสินค้า
│   └── pubspec.yaml             # ไฟล์กำหนดค่าและการพึ่งพา (dependencies)
│
└── api/
    └── app.py                   # API สำหรับจัดการข้อมูลสินค้า
```

## ส่วนประกอบหลัก

### 1. แอปพลิเคชันมือถือ (Flutter)

- **main.dart**: เป็นจุดเริ่มต้นของแอปพลิเคชัน กำหนดธีมและเรียกใช้หน้าจอหลัก
- **main_screen.dart**: แสดงรายการสินค้าและมีฟังก์ชันสำหรับการจัดการสินค้า (CRUD)
- **notify.dart**: จัดการการแจ้งเตือนภายในแอปพลิเคชัน
- **product_model.dart**: กำหนดโครงสร้างข้อมูลสินค้า

### 2. API (FastAPI)

- **app.py**: ให้บริการ API สำหรับการจัดการข้อมูลสินค้า ใช้ฐานข้อมูล SQLite เพื่อจัดเก็บข้อมูล

## คุณสมบัติหลัก

- **การแสดงรายการสินค้า**: แสดงรายการสินค้าทั้งหมดพร้อมรายละเอียด
- **การเพิ่มสินค้า**: เพิ่มสินค้าใหม่ด้วยการระบุ รหัส, ชื่อ, ราคา และจำนวน
- **การแก้ไขสินค้า**: แก้ไขข้อมูลสินค้าที่มีอยู่
- **การลบสินค้า**: ลบสินค้าที่ไม่ต้องการ โดยต้องผ่านการยืนยันตัวตนด้วยชีวมิติ
- **การแจ้งเตือน**: แสดงการแจ้งเตือนเมื่อดำเนินการกับสินค้าสำเร็จหรือเกิดข้อผิดพลาด
- **การยืนยันตัวตนด้วยชีวมิติ**: ป้องกันการลบข้อมูลโดยไม่ได้ตั้งใจด้วยการยืนยันลายนิ้วมือหรือใบหน้า

## ขั้นตอนการติดตั้ง

### การติดตั้ง API (FastAPI)

1. ติดตั้ง Python 3.6+ หากยังไม่ได้ติดตั้ง
2. ติดตั้ง dependencies:
   ```
   pip install fastapi uvicorn sqlite3 pydantic
   ```
3. รันเซิร์ฟเวอร์:
   ```
   python app.py
   ```
   หรือ
   ```
   uvicorn app:app --host 0.0.0.0 --port 8000 --reload
   ```

### การติดตั้งแอปพลิเคชัน Flutter

1. ติดตั้ง Flutter SDK หากยังไม่ได้ติดตั้ง
2. นำเข้าโปรเจค
  2.1 เพิ่มตั้งค่าใน `android/gradlew.bat` line at 75
  ```bat
  org.gradle.wrapper.GradleWrapperMain %CMD_LINE_ARGS% --offline
  ```
3. ติดตั้ง dependencies:
   ```
   flutter pub get --offline
   ```
4. ตั้งค่า Biometric Authentication และ Local Notifications (ดูรายละเอียดด้านล่าง)
5. รันแอปพลิเคชัน:
   ```
   flutter run
   ```

### การตั้งค่า Biometric Authentication (Android)

1. เพิ่มการขออนุญาตใน `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.USE_BIOMETRIC" />
   ```

2. ตั้งค่า minSdkVersion ใน `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       ...
       minSdkVersion 23 // หรือสูงกว่า สำหรับ Biometric
       ...
   }
   ```

3. ตั้งค่า ใน `android/app/src/main/kotlin/com/example/flutter_app/MainActivity.kt`:
   ```kotlin
    package com.example.flutter_app
    import android.os.Bundle
    import io.flutter.embedding.android.FlutterFragmentActivity
    class MainActivity: FlutterFragmentActivity()
   ```

### การตั้งค่า Local Notifications (Android)

1. เพิ่มการขออนุญาตใน `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
   <uses-permission android:name="android.permission.VIBRATE" />
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
   ```

2. เพิ่ม Receiver ในแท็ก `<application>`:
   ```xml
   <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
   <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
       <intent-filter>
           <action android:name="android.intent.action.BOOT_COMPLETED"/>
           <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
           <action android:name="android.intent.action.QUICKBOOT_POWERON" />
           <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
       </intent-filter>
   </receiver>
   ```

3. ถ้าพัฒนาสำหรับ Android 13 หรือสูงกว่า ต้องจัดการการขออนุญาตแจ้งเตือนในโค้ด:
   ```dart
   // เพิ่มในไฟล์ notify.dart ในฟังก์ชัน initNotify()
   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
   ```

## การใช้งาน API

API มีเอนด์พอยต์หลักดังนี้:

- `GET /products/`: ดึงรายการสินค้าทั้งหมด
- `GET /products/{product_code}`: ดึงข้อมูลสินค้าตามรหัส
- `POST /products/`: เพิ่มสินค้าใหม่
- `PUT /products/{product_code}`: อัปเดตข้อมูลสินค้า
- `DELETE /products/{product_code}`: ลบสินค้า

## การใช้งานแอปพลิเคชัน

1. **การดูรายการสินค้า**: เมื่อเปิดแอปพลิเคชัน รายการสินค้าจะแสดงขึ้นโดยอัตโนมัติ
2. **การเพิ่มสินค้า**: กดปุ่ม "เพิ่มสินค้า" และกรอกข้อมูลในฟอร์ม
3. **การแก้ไขสินค้า**: กดไอคอนแก้ไข (รูปดินสอ) ที่สินค้าที่ต้องการแก้ไข และแก้ไขข้อมูลในฟอร์ม
4. **การลบสินค้า**: กดไอคอนลบ (รูปถังขยะ) ที่สินค้าที่ต้องการลบ ยืนยันตัวตนด้วยชีวมิติ และยืนยันการลบ

## ข้อกำหนดทางเทคนิค

- Flutter 3.6.0+
- Dart 3.0+
- Python 3.6+
- FastAPI
- SQLite
- Android API Level 23+ (Android 6.0+) สำหรับ Biometric Authentication
- ต้องมีการตั้งค่าลายนิ้วมือหรือการยืนยันตัวตนด้วยใบหน้าบนอุปกรณ์

### แพ็คเกจที่ใช้
- **Flutter:**
  - `http`: สำหรับการเชื่อมต่อกับ API
  - `local_auth`: สำหรับการยืนยันตัวตนด้วยชีวมิติ
  - `flutter_local_notifications`: สำหรับการแสดงการแจ้งเตือน
  - `timezone`: สำหรับการจัดการเขตเวลาในการแจ้งเตือน

- **Python:**
  - `fastapi`: สำหรับสร้าง API
  - `uvicorn`: สำหรับรัน ASGI server
  - `pydantic`: สำหรับการตรวจสอบข้อมูล
  - `sqlite3`: สำหรับการจัดการฐานข้อมูล

## การแก้ไขปัญหาเบื้องต้น

1. **ไม่สามารถเชื่อมต่อกับ API**:
   - ตรวจสอบว่า API เซิร์ฟเวอร์กำลังทำงานอยู่
   - ตรวจสอบว่า URL ฐาน (`baseUrl`) ในไฟล์ `main_screen.dart` ถูกต้อง
   - สำหรับการทดสอบบน Android Emulator ต้องใช้ IP `10.0.2.2` แทน `localhost`

2. **การยืนยันตัวตนด้วยชีวมิติไม่ทำงาน**:
   - ตรวจสอบว่าอุปกรณ์รองรับการยืนยันตัวตนด้วยชีวมิติ
   - ตรวจสอบว่าได้ตั้งค่าลายนิ้วมือหรือการยืนยันตัวตนด้วยใบหน้าในอุปกรณ์แล้ว
   - ตรวจสอบว่าได้เพิ่ม permission `android.permission.USE_BIOMETRIC` ใน AndroidManifest.xml
   - ตรวจสอบว่า minSdkVersion ใน build.gradle ตั้งค่าเป็น 23 หรือสูงกว่า

3. **การแจ้งเตือนไม่ทำงาน**:
   - ตรวจสอบว่าได้เพิ่ม permissions สำหรับการแจ้งเตือนใน AndroidManifest.xml
   - สำหรับ Android 13 (API level 33) ขึ้นไป ต้องขออนุญาตแจ้งเตือนแบบ runtime
   - ตรวจสอบว่าได้เรียกใช้ `requestNotificationsPermission()` สำหรับ Android

## การพัฒนาต่อยอด

1. **เพิ่มระบบล็อกอิน**: พัฒนาระบบล็อกอินเพื่อจำกัดการเข้าถึงข้อมูล
2. **เพิ่มคุณสมบัติการค้นหา**: เพิ่มฟิลเตอร์และการค้นหาสินค้า
3. **เพิ่มการจัดการหมวดหมู่**: จัดการหมวดหมู่ของสินค้า
4. **รายงานและการวิเคราะห์**: เพิ่มรายงานและกราฟวิเคราะห์ข้อมูลสินค้า