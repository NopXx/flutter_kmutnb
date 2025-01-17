import 'package:flutter/material.dart';
import 'package:week7/models/datamap.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String txt = "";
  List<Map<String, dynamic>> mydata = [
    {"id": 1, "name": "John", "age": 20},
    {"id": 2, "name": "Alice", "age": 22},
    {"id": 3, "name": "Bob", "age": 21},
    {"id": 4, "name": "Charlie", "age": 22},
    {"id": 5, "name": "David", "age": 21},
    {"id": 6, "name": "Eve", "age": 21},
    {"id": 7, "name": "Frank", "age": 21},
    {"id": 8, "name": "Grace", "age": 18},
    {"id": 9, "name": "Hannah", "age": 21},
    {"id": 10, "name": "Iris", "age": 19},
    {"id": 11, "name": "Jack", "age": 18},
    {"id": 12, "name": "Kim", "age": 19},
    {"id": 13, "name": "Lisa", "age": 20},
    {"id": 14, "name": "Mary", "age": 16},
    {"id": 15, "name": "Nancy", "age": 17},
    {"id": 16, "name": "Olivia", "age": 19},
    {"id": 17, "name": "Peter", "age": 16},
    {"id": 18, "name": "Quinn", "age": 16},
    {"id": 19, "name": "Rachel", "age": 16},
    {"id": 20, "name": "Sarah", "age": 16},
  ];
  List<Datamap> list = [];
  
  @override
  void initState() {
    super.initState();
    txt = mydata.toString();
    list = mydata.map((item) => Datamap.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Data Access'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildlist2(list)
          ],
        ),
      ),
    );
  }
  
  Widget _buildlist(List<Map<String, dynamic>> data) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: 
          data.map((json) => Card(
            child: ListTile(
              title: Text('${json['id']} : ${json['name']}'),
              subtitle: Text('Age : ${json['age']}'),
            ),
          )).toList(),
        
      ),
    );
  }
  Widget _buildlist2(List<Datamap> data) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: 
          data.map((json) => Card(
            child: ListTile(
              title: Text('${json.id} : ${json.name}'),
              subtitle: Text('Age : ${json.age}'),
            ),
          )).toList(),
        
      ),
    );
  }
}
