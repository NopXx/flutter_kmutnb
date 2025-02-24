// ignore: file_names
class UserInfo {
  int? id;
  final String name;
  final int age;
  final bool hobby;
  final bool internet;

  UserInfo({
    this.id,
    required this.name,
    required this.age,
    required this.hobby,
    required this.internet,
  });

  // Convert from database map.
  static UserInfo fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      hobby: (map['hobby'] as int) == 1, // Convert INTEGER to bool
      internet: (map['internet'] as int) == 1, // Convert INTEGER to bool
    );
  }

  // Convert to database map.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'hobby': hobby ? 1 : 0, // Convert bool to INTEGER
      'internet': internet ? 1 : 0, // Convert bool to INTEGER
    };
  }

  @override
  String toString() {
    return 'UserInfo{id: $id, name: $name, age: $age, hobby: $hobby, internet: $internet}';
  }
}
