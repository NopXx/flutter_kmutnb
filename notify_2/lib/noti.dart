// ignore_for_file: avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Noti {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TimeOfDay? _selectedTime;

  Noti() {
    initNoti();
  } // constructor

  Future<void> initNoti() async {
    WidgetsFlutterBinding.ensureInitialized();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize timezone data
    tz.initializeTimeZones();
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "test_channel",
      "Test Notifications",
      channelDescription: "Channel for immediate test notifications",
      importance: Importance.high,
      priority: Priority.defaultPriority,
      ticker: "ticker",
    );

    NotificationDetails platformAndroid =
        const NotificationDetails(android: androidNotificationDetails);

    int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await flutterLocalNotificationsPlugin.show(
      id,
      "⚠️ Test Notification",
      "This is an immediate test notification with ID: $id",
      platformAndroid,
      payload: "test_payload_$id",
    );

    print('Immediate notification sent');
  }

  Future<TimeOfDay> settime(BuildContext context) async {
    TimeOfDay initialTime = _selectedTime ?? TimeOfDay.now();
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (time != null) {
      _selectedTime = time;
    }
    return _selectedTime ?? initialTime;
  }

  Future<void> schedule(int hour, int minute) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "alarm_channel",
      "Scheduled Alarms",
      channelDescription: "Channel for scheduled alarm notifications",
      importance: Importance.high,
      priority: Priority.defaultPriority,
      ticker: "ticker",
    );

    NotificationDetails platformAndroid =
        const NotificationDetails(android: androidNotificationDetails);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    print("Alarm at $scheduledDate");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(10000),
      'Schedule Notify',
      "Schedule at ${scheduledDate.toString()}",
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformAndroid,
      payload: scheduledDate.toString(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  Future<void> schedule15s() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "alarm_channel",
      "Scheduled Alarms",
      channelDescription: "Channel for scheduled alarm notifications",
      importance: Importance.high,
      priority: Priority.defaultPriority,
      ticker: "ticker",
    );

    NotificationDetails platformAndroid =
        const NotificationDetails(android: androidNotificationDetails);

    // Get current time
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Add 15 seconds to current time
    tz.TZDateTime scheduledDate = now.add(const Duration(seconds: 15));

    print("Notification scheduled at $scheduledDate");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(10000),
      'Notification Alert',
      "Scheduled for ${scheduledDate.toString()}",
      scheduledDate,
      platformAndroid,
      payload: scheduledDate.toString(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  Future<List<PendingNotificationRequest>> listAllpending() async {
    final List<PendingNotificationRequest> pendingRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    
    return pendingRequests;
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('All notifications canceled');
  }

  Future<void> cancelbyID(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print('Notification with ID $id canceled');
  }
}
