import 'package:flutter/material.dart';
import 'package:sqlite/dbhelper.dart';
import 'package:sqlite/model/Dog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _dbHelper = Dbhelper.instance;
  List<Dog> dogs = [];
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void addDog(int id, String name, int age) async {
    await _dbHelper.insertDog(
        Dog(id: id, name: name, age: age)); // ID is null for auto-increment
    getData();
  }

  void getData() async {
    final data = await _dbHelper.queryAll();
    setState(() {
      dogs = data;
    });
  }

  void showAddDogSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(Icons.close)),
                    ElevatedButton(
                      onPressed: () {
                        if (idController.text.isNotEmpty &&
                            nameController.text.isNotEmpty &&
                            ageController.text.isNotEmpty) {
                          addDog(
                              int.parse(idController.text),
                              nameController.text,
                              int.parse(ageController.text));
                          idController.clear();
                          nameController.clear();
                          ageController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Add Dog',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dog Id',
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Dog Name'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Dog'),
        actions: [
          IconButton(
            onPressed: showAddDogSheet,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: dogs.length,
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text('ID : ${dogs[index].id}'),
                        const SizedBox(width: 8),
                        Text(dogs[index].name),
                      ],
                    ),
                    subtitle: Text('Age: ${dogs[index].age}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final edit_id = TextEditingController();
                            edit_id.text = dogs[index].id.toString();
                            final edit_name = TextEditingController();
                            edit_name.text = dogs[index].name;
                            final edit_age = TextEditingController();
                            edit_age.text = dogs[index].age.toString();

                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: edit_id,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Dog ID',
                                        ),
                                      ),
                                      TextField(
                                        controller: edit_name,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          labelText: 'Dog Name',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: edit_age,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          labelText: 'Age',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.grey,
                                            ),
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final dog = Dog(
                                                id: int.parse(edit_id.text),
                                                name: edit_name.text,
                                                age: int.parse(edit_age.text),
                                              );
                                              _dbHelper.updateDog(dog);
                                              setState(() {
                                                getData();
                                              });
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                            child: Text(
                                              'Update',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.amber,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(
                                          text: dogs[index].id.toString(),
                                        ),
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Dog ID',
                                        ),
                                      ),
                                      TextField(
                                        controller: TextEditingController(
                                          text: dogs[index].name,
                                        ),
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Dog Name',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(
                                          text: dogs[index].age.toString(),
                                        ),
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Age',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.grey,
                                            ),
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _dbHelper
                                                  .deleteDog(dogs[index].id);
                                              setState(() {
                                                getData();
                                              });
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
