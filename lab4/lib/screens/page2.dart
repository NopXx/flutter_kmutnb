import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _outputController = TextEditingController();
  List<int> numbers = [];
  final TextEditingController _inputController = TextEditingController();
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Page 2'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _outputController,
                  decoration: const InputDecoration(
                      label: Text('Output'), border: OutlineInputBorder()),
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  readOnly: true,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (numbers.isEmpty) {
                            numbers.add(1);
                          } else {
                            numbers.add(numbers.last + 1);
                          }
                          text += '$numbers\n';
                          _outputController.text = text;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add'),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (numbers.isNotEmpty) {
                            numbers.removeLast();
                            text = '';
                            for (var i = 0; i < numbers.length; i++) {
                              text += '${numbers.sublist(0, i + 1)}\n';
                            }
                          }
                          _outputController.text = text;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Del'),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ListView.separated(
                                itemCount: numbers.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Text('$index'),
                                      title: Text('${numbers[index]}'),
                                      trailing: InkWell(
                                          onTap: () {
                                            _inputController.text =
                                                '${numbers[index]}';
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Edit Number'),
                                                  content: TextField(
                                                    controller:
                                                        _inputController,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Enter a new number',
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          numbers[index] =
                                                              int.parse(_inputController.text);
                                                          text = '';
                                                          for (var i = 0; i < numbers.length; i++) {
                                                            text += '${numbers.sublist(0, i + 1)}\n';
                                                          }
                                                          _outputController.text = text;
                                                          _inputController.clear();
                                                        });
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Save'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.edit)),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200]),
                      child: const Text('Edit', 
                                          style: TextStyle(
                                            color: Colors.white,
                                            ),
                                          ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          numbers.clear();
                          _outputController.text = '';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
