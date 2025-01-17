class Datamap {
  final int id;
  final String name;
  final int age;

  static final Map<String, dynamic> info = {
    'id': '',
    'name': '',
    'age': '',
  };

  Datamap({
    required this.id,
    required this.name,
    required this.age,
  });

  static Datamap fromJson(Map<String, dynamic> json) => Datamap(
        id: json['id'],
        name: json['name'],
        age: json['age'],
      );

  Map<String, dynamic> toJson() => {
        info['id']: id,
        info['name']: name,
        info['age']: age,
      };
}
