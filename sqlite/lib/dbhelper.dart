import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/model/Dog.dart';

class Dbhelper {
  Dbhelper._instance();
  static final Dbhelper instance = Dbhelper._instance();
  static Database? _database;

  Future<Database> get db async {
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'dogdb.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      """
        CREATE TABLE dogs(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          age INTEGER
          )
        """,
    );
  }

  Future<int> insertDog(Dog dog) async {
    Database db = await instance.db;
    return await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // update
  Future<void> updateDog(Dog dog) async {
    Database db = await instance.db;
    await db.update(
      'dogs',
      dog.toMap(),
      where: 'id =?',
      whereArgs: [dog.id],
    );
  }

  Future<List<Dog>> queryAll() async {
    Database db = await instance.db;
    return (await db.query('dogs')).map((row) => Dog.fromMap(row)).toList();
  }

  Future<void> deleteDog(int id) async {
    Database db = await instance.db;
    await db.delete(
      'dogs',
      where: 'id =?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    Database db = await instance.db;
    await db.delete('dogs');
  }
}
