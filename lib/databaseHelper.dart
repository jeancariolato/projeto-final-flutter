import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agendamentos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE agendamentos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nomeResponsavel TEXT,
            data TEXT,
            horariosSelecionados TEXT,
            valorTotal REAL,
          )
        ''');
      },
    );
  }

  Future close() async{
    final db = await database;
    db.close();
  }


}
