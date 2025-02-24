import 'package:flutter/material.dart';
import 'package:quiztest/db_helper.dart';
import 'package:quiztest/user.dart'; // ตรวจสอบ path และชื่อไฟล์

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MyApp());
}

void init() async {
  await DatabaseHelper.instance.database;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const UserHomePage(), // ต้องเรียก UserHomePage() ไม่ใช่ UserInfo()
      debugShowCheckedModeBanner: false,
    );
  }
}
