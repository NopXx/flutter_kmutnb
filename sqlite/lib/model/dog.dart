// ignore: file_names
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  
  // Convert a Map into a Dog. The keys must correspond to the names of the
  // columns in the database.
  static Dog fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}