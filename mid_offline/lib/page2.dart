import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page2 extends StatefulWidget {
  final String name;
  const Page2({super.key, required this.name});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  String title = '';

  void loadData() async {
    final perf = await SharedPreferences.getInstance();
    setState(() {
      title = perf.getString('user').toString();
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
        title: Text(title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'This is Page 2',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            'Message : ${widget.name}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context, 'Hi From Page 2');
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.pink),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            icon: Icon(Icons.arrow_back_ios),
            label: Text('Go to Page 1'),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },),
          )
        ],
      ),
    );
  }
}
