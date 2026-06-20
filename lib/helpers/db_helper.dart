import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('zouwar_station.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT UNIQUE,
        password TEXT,
        role TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE shifts (
        id INTEGER PRIMARY KEY,
        shiftName TEXT,
        userId INTEGER,
        date TEXT,
        startTime TEXT,
        endTime TEXT,
        openingCash REAL,
        closingCash REAL,
        status INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY,
        shiftId INTEGER,
        type TEXT,
        pumpNumber INTEGER,
        amount REAL,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY,
        shiftId INTEGER,
        description TEXT,
        amount REAL,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tanks (
        id INTEGER PRIMARY KEY,
        name TEXT,
        capacity REAL,
        currentLevel REAL
      )
    ''');
  }

  Future<int> startShift(double openingCash) async {
    Database db = await instance.database;
    return await db.insert('shifts', {
      'shiftName': 'وردية ${DateTime.now().hour}',
      'date': DateTime.now().toString().split(' ')[0],
      'startTime': DateTime.now().toString(),
      'openingCash': openingCash,
      'status': 1
    });
  }

  Future<Map<String, dynamic>?> getActiveShift() async {
    Database db = await instance.database;
    final result = await db.query('shifts', where: 'status = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertSale(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('sales', row);
  }

  Future<double> getSalesTotalForShift(int shiftId) async {
    Database db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM sales WHERE shiftId = ?',
      [shiftId]
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getSalesSummary() async {
    Database db = await instance.database;
    return await db.rawQuery(
      'SELECT type, SUM(amount) as total FROM sales GROUP BY type'
    );
  }

  Future<int> insertExpense(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('expenses', row);
  }

  Future<double> getExpensesTotalForShift(int shiftId) async {
    Database db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE shiftId = ?',
      [shiftId]
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getMonthlySales() async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT strftime('%m-%Y', createdAt) as month, SUM(amount) as total
      FROM sales
      GROUP BY month
      ORDER BY month DESC
    ''');
  }

  Future<int> insertTank(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('tanks', row);
  }

  Future<List<Map<String, dynamic>>> getAllTanks() async {
    Database db = await instance.database;
    return await db.query('tanks');
  }

  Future<void> updateTankLevel(int tankId, double quantitySold) async {
    Database db = await instance.database;
    await db.rawUpdate(
      'UPDATE tanks SET currentLevel = currentLevel - ? WHERE id = ?',
      [quantitySold, tankId]
    );
  }

  Future<void> closeShift(int shiftId, double closingCash) async {
    Database db = await instance.database;
    await db.update(
      'shifts',
      {
        'status': 0,
        'closingCash': closingCash,
        'endTime': DateTime.now().toString()
      },
      where: 'id = ?',
      whereArgs: [shiftId]
    );
  }
}