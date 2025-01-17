import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int count = 0;

  Future<void> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      count = pref.getInt('count') ?? 0;
    });
  }

  void setCount() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      count++;
      pref.setInt('count', count);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Offline'),
      ),
      body: Column(
        children: [
          Text('Count is : $count'),
          SizedBox(
            height: 8,
          ),
          IconButton(onPressed: setCount, icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
