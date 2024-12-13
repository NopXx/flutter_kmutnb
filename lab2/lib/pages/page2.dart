import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Page 2'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go to Page 1'),
            ),
          ],
        ),
      ),
    );
  }
}