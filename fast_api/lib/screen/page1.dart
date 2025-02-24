import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final String BASE_URL = "http://10.0.2.2:8000";
  List<dynamic> books = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/books"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          books = data;
        });
        log(books.toString());
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void addBook(String title, String author, int year) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/book'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
            {'id': '0', 'title': title, 'author': author, 'year': year}),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception('Failed to add book');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void updateBook(int index, String title, String author, int year) async {
    try {
      final response = await http.put(
        Uri.parse('$BASE_URL/book/$index'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
            {'id': index, 'title': title, 'author': author, 'year': year}),
      );
      log(response.body);
      if (response.statusCode == 200) {
        fetchData();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
            const SnackBar(content: Text('Book updated successfully')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
            const SnackBar(content: Text('Book updated failed')));
        throw Exception('Failed to update book');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void deleteBook(int index) async {
    try {
      final response = await http.delete(Uri.parse('$BASE_URL/book/$index'));
      if (response.statusCode == 200) {
        fetchData();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
            const SnackBar(content: Text('Book deleted successfully')));
      } else {
        throw Exception('Failed to delete book');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showAddBook() {
    final _title = TextEditingController();
    final _author = TextEditingController();
    final _year = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _title,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _author,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: _year,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addBook(_title.text, _author.text, int.parse(_year.text));
                  Navigator.pop(context);
                },
                child: Text('Add Book'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditBook(data) {
    final _title = TextEditingController();
    _title.text = data['title'];
    final _author = TextEditingController();
    _author.text = data['author'];
    final _year = TextEditingController();
    _year.text = data['year'].toString();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _title,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _author,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: _year,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateBook(data['id'], _title.text, _author.text,
                      int.parse(_year.text));
                  Navigator.pop(context);
                },
                child: Text('Update Book'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FastAPI'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddBook,
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: fetchData,
            child: Text('Fetch Data'),
          ),
          Expanded(
            child: books.isEmpty
                ? Center(child: Text('No data available'))
                : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        child: ListTile(
                          onTap: () => showEditBook(book),
                          leading: Icon(Icons.menu_book_outlined),
                          title: Text('Title : ${book['title']}'),
                          subtitle: Text(
                              'Author : ${book['author']}\nYear : ${book['year']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Delete Book'),
                                          content: Text('Are you sure?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                deleteBook(book['id']);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Delete'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
