import 'package:flutter/material.dart';
import 'package:sqlite/dbhelper.dart';
import 'package:sqlite/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(MyApp());
}

void init() async {
  await Dbhelper.instance.db;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Home(),
    );
  }
}