import 'package:flutter/material.dart';
import 'package:quiztest/db_helper.dart';
import 'package:quiztest/model/user_info.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<UserInfo> _users = [];
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  bool hobby = false;
  bool internet = false;
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await dbHelper.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Add User'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    title: const Text('Hobby'),
                    value: hobby,
                    onChanged: (bool? value) {
                      setStateDialog(() {
                        hobby = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Internet'),
                    value: internet,
                    onChanged: (bool? value) {
                      setStateDialog(() {
                        internet = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Reset values after canceling
                  hobby = false;
                  internet = false;
                  nameController.clear();
                  ageController.clear();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final age = int.tryParse(ageController.text.trim()) ?? 0;

                  if (name.isEmpty || age <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid name and age.')),
                    );
                    return;
                  }

                  final newUser = UserInfo(
                    id: 0, // SQLite will auto-generate the ID
                    name: name,
                    age: age,
                    hobby: hobby,
                    internet: internet,
                  );

                  await dbHelper.createUser(newUser);
                  await _loadUsers(); // Reload the list from database

                  // Reset values after adding
                  hobby = false;
                  internet = false;
                  nameController.clear();
                  ageController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Record'),
              ),
            ],
          );
        });
      },
    );
  }

  void _editUser(UserInfo user) {
    final editNameController = TextEditingController(text: user.name);
    final editAgeController = TextEditingController(text: user.age.toString());
    bool editHobby = user.hobby;
    bool editInternet = user.internet;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Edit User'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: editNameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: editAgeController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    title: const Text('Hobby'),
                    value: editHobby,
                    onChanged: (bool? value) {
                      setStateDialog(() {
                        editHobby = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Internet'),
                    value: editInternet,
                    onChanged: (bool? value) {
                      setStateDialog(() {
                        editInternet = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final name = editNameController.text.trim();
                  final age = int.tryParse(editAgeController.text.trim()) ?? 0;

                  if (name.isEmpty || age <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid name and age.')),
                    );
                    return;
                  }

                  final updatedUser = UserInfo(
                    id: user.id,
                    name: name,
                    age: age,
                    hobby: editHobby,
                    internet: editInternet,
                  );

                  await dbHelper.updateUser(updatedUser);
                  await _loadUsers(); // Reload the list from database

                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteUser(UserInfo user) async {
    await dbHelper.deleteUser(user.id!);
    await _loadUsers(); // Reload the list from database
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    dbHelper.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User CRUD')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text('${user.name} (Age: ${user.age})'),
              subtitle: Text(
                  'Hobby: ${user.hobby ? 'Yes' : 'No'}, Internet: ${user.internet ? 'Yes' : 'No'}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editUser(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(user),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}