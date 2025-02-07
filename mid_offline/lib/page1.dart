import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mid_offline/page2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String message = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is Page 1',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            message.isNotEmpty
                ? Text(
                    'Message : $message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a message',
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                final perf = await SharedPreferences.getInstance();
                setState(() {
                  perf.setString('user', _controller.text);
                  double.parse(_controller.text); 
                });
                log(perf.getString('user').toString());
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page2(
                      name: 'Hello From Page 1',
                    ),
                  ),
                );
                if (result != '') {
                  setState(() {
                    message = result;
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.pink),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              icon: Icon(Icons.arrow_forward_ios),
              label: Text('Go to Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}
