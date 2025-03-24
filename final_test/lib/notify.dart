// นำเข้าแพคเกจที่จำเป็นสำหรับการสร้าง UI, การแจ้งเตือน และการจัดการเขตเวลา
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // แพคเกจสำหรับจัดการการแจ้งเตือนในแอป
import 'package:timezone/data/latest.dart' as tz; // แพคเกจสำหรับจัดการเขตเวลา จำเป็นสำหรับการแจ้งเตือนแบบกำหนดเวลา

// คลาส Notify ใช้สำหรับจัดการการแจ้งเตือนในแอพพลิเคชัน
class Notify {
  // สร้างตัวแปรสำหรับปลั๊กอินการแจ้งเตือน
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Constructor ของคลาส เมื่อสร้างอ็อบเจ็กต์จะเรียกใช้ initNotify ทันที
  Notify() {
    initNotify();
  }

  // ฟังก์ชันเริ่มต้นการตั้งค่าการแจ้งเตือน
  Future<void> initNotify() async {
    // เริ่มต้น WidgetsFlutterBinding ซึ่งจำเป็นสำหรับการใช้งาน Flutter Plugin ในบริบทที่ไม่มี runApp
    WidgetsFlutterBinding.ensureInitialized();

    // ขออนุญาตแสดงการแจ้งเตือนสำหรับ Android
    // สำคัญมากสำหรับ Android 13 (API 33) ขึ้นไปที่ต้องขออนุญาตแบบ runtime
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        
    // โค้ดสำรองสำหรับ Android 13 (คอมเมนต์ไว้เพราะซ้ำซ้อนกับด้านบน)
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestNotificationsPermission();

    // กำหนดการตั้งค่าเริ่มต้นสำหรับ Android
    // @mipmap/ic_launcher คือไอคอนเริ่มต้นของแอป ซึ่งจะถูกใช้เป็นไอคอนการแจ้งเตือน
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // กำหนดการตั้งค่าเริ่มต้นสำหรับทุกแพลตฟอร์ม (ในตัวอย่างนี้มีเฉพาะ Android)
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    // เริ่มต้นปลั๊กอินการแจ้งเตือนด้วยการตั้งค่าที่กำหนด
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // เริ่มต้นข้อมูลเขตเวลา จำเป็นสำหรับการแจ้งเตือนแบบกำหนดเวลา
    tz.initializeTimeZones();
  }

  // ฟังก์ชันสำหรับแสดงการแจ้งเตือน
  Future<void> showNotification(String title, String body) async {
    // กำหนดรายละเอียดของการแจ้งเตือนสำหรับ Android
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channelId',      // รหัสช่องทางการแจ้งเตือน ต้องไม่เปลี่ยนแปลงถ้าต้องการให้การตั้งค่าไม่เปลี่ยน
          'channelName',    // ชื่อช่องทางการแจ้งเตือนที่ผู้ใช้จะเห็น
          importance: Importance.high,  // ระดับความสำคัญของการแจ้งเตือน (high จะทำให้แสดงเป็น pop-up)
          priority: Priority.defaultPriority,  // ลำดับความสำคัญของการแจ้งเตือน
          ticker: "ticker"  // ข้อความสำหรับ Accessibility Service เช่น TalkBack
        );

    // สร้างรายละเอียดการแจ้งเตือนสำหรับทุกแพลตฟอร์ม (ในที่นี้คือ Android)
    NotificationDetails platformAndroid = const NotificationDetails(
      android: androidNotificationDetails,
    );

    // สร้าง ID ที่ไม่ซ้ำกันสำหรับการแจ้งเตือน โดยใช้เวลาปัจจุบันและทำให้ไม่ยาวเกินไป
    int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // แสดงการแจ้งเตือน
    await flutterLocalNotificationsPlugin.show(
      id,             // ID ของการแจ้งเตือน
      title,          // หัวข้อการแจ้งเตือน
      body,           // เนื้อหาการแจ้งเตือน
      platformAndroid, // รายละเอียดการแจ้งเตือน
      payload: "payload_$id",  // ข้อมูลเพิ่มเติมที่สามารถใช้เมื่อผู้ใช้แตะที่การแจ้งเตือน
    );
  }
}