// lib/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'practice_result.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'practice_results.db');
    return await openDatabase(
      path,
      version: 2, // 데이터베이스 버전을 2로 유지합니다. (이전 오류 해결을 위해)
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: onDatabaseDowngradeDelete, // 개발 중 스키마 변경 시 유용
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE practice_results(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correctText TEXT NOT NULL,         -- 추가된 컬럼
        recognizedText TEXT NOT NULL,
        cer REAL,
        mfccSimilarity REAL,               -- 추가된 컬럼
        timestamp TEXT NOT NULL,
        recognizedAudioPath TEXT
      )
    ''');
    print('Database created with version $version');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Database upgrade from version $oldVersion to $newVersion');

    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE practice_results ADD COLUMN correctText TEXT;');
        print('Column correctText added to practice_results.');
      } catch (e) {
        // 컬럼이 이미 존재하는 경우의 예외 처리 (무시)
        print('Column correctText already exists or error adding: $e');
      }

      try {
        await db.execute('ALTER TABLE practice_results ADD COLUMN mfccSimilarity REAL;');
        print('Column mfccSimilarity added to practice_results.');
      } catch (e) {
        print('Column mfccSimilarity already exists or error adding: $e');
      }

      try {
        await db.execute('ALTER TABLE practice_results ADD COLUMN recognizedAudioPath TEXT;');
        print('Column recognizedAudioPath added to practice_results.');
      } catch (e) {
        print('Column recognizedAudioPath already exists or error adding: $e');
      }
    }
  }

  Future<int> insertPracticeResult(PracticeResult result) async {
    Database db = await instance.database;
    return await db.insert('practice_results', result.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PracticeResult>> getPracticeResults() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'practice_results',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      return PracticeResult.fromMap(maps[i]);
    });
  }

  Future<int> deletePracticeResult(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'practice_results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}