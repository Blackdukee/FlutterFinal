import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finalproject/models/diet_model.dart';
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('diet.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE diets (
  id $idType,
  name $textType,
  ingredients $textType,
  iconPath $textType,
  level $textType,
  duration $textType,
  calorie $textType,
  boxColor $intType,
  viewIsSelected $boolType
  )
''');
  }

  Future<int> create(DietModel diet) async {
    final db = await instance.database;

    return await db.insert('diets', diet.toMap());
  }

  Future<DietModel?> readDiet(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'diets',
      columns: [
        'id',
        'name',
        'ingredients',
        'iconPath',
        'level',
        'duration',
        'calorie',
        'boxColor',
        'viewIsSelected'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DietModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<DietModel>> readAllDiets() async {
    final db = await instance.database;

    final result = await db.query('diets');

    return result.map((json) => DietModel.fromMap(json)).toList();
  }

  Future<int> update(DietModel diet ,int id) async {
    final db = await instance.database;

    return db.update(
      'diets',
      diet.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'diets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}