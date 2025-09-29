import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class LocalDb {
  static Database? _db;
  static Future<Database> getDb() async {
    if (_db!=null) return _db!;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'users.db');
    _db = await openDatabase(path, version:1, onCreate: (db, v) async {
      await db.execute('''CREATE TABLE users (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, avatar TEXT)''');
    });
    return _db!;
  }

  static Future<void> saveUsers(List<UserModel> users) async {
    final db = await getDb();
    final batch = db.batch();
    for (var u in users) {
      batch.insert('users', u.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<List<UserModel>> getCachedUsers() async {
    final db = await getDb();
    final rows = await db.query('users');
    return rows.map((r) => UserModel(id: r['id'] as int, firstName: r['first_name'] as String, lastName: r['last_name'] as String, avatar: r['avatar'] as String)).toList();
  }
}
