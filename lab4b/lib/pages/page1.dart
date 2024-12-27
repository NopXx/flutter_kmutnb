import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Page1 extends StatefulWidget {
  String title = '';
  Page1({super.key, required this.title});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<String> items = List.generate(10, (index) => "Text $index");
  List<String> item_sub = List.generate(10, (index) => "Subtitle $index");

  late int idx = 0;
  late TextEditingController _controller = TextEditingController();
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        margin: const EdgeInsets.all(10),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Nopparat Khamkokaew'),
              const SizedBox(
                height: 8.0,
              ),
              const Text('6606021421012'),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            setState(() {
                              items.removeAt(index);
                              showMessage('Removed item at index: $index');
                            });
                          },
                          child: Container(
                            height: 75,
                            color: idx == index ? Colors.blue : null,
                            child: ListTile(
                              leading: const Icon(
                                Icons.ac_unit_outlined,
                                color: Colors.red,
                              ),
                              title: Text(items[index]),
                              subtitle: Text(item_sub[index]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _controller.text = items[index];
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                margin: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              items[index] =
                                                                  _controller
                                                                      .text;
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Text('Edit Item'),
                                                    const SizedBox(height: 8),
                                                    TextField(
                                                      controller: _controller,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: 'Edit Item',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          items.removeAt(index);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Remove Success',
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Rounded corners
                                              ),
                                              margin: const EdgeInsets.all(10),
                                              backgroundColor: Colors.black,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        });
                                      },
                                      icon:
                                          const Icon(Icons.remove_circle_outline))
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  idx = index;
                                });
                              },
                            ),
                          ));
                    }),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        items.clear();
                        showMessage('Gen list');
                        items = List.generate(10, (index) => "Text $index");
                      });
                    },
                    child: const Text('Gen new list'),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            items.add(_controller.text);
                                            Navigator.pop(context);
                                            showMessage("Add Item to index of ${items.lastIndexOf(_controller.text)}");
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('Add Item'),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Item Name',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                    },
                    child: const Text('Add item to list'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
