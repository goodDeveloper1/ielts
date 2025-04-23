import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StaticWordDatabase {
  static final StaticWordDatabase _instance = StaticWordDatabase._internal();
  factory StaticWordDatabase() => _instance;
  StaticWordDatabase._internal();

  static Database? _db;

  // Getter that lazy-loads db
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();  // FINAL assignment happens here
    return _db!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "words.db");

    // Only copy if file doesn’t exist
    if (!File(path).existsSync()) {
      ByteData data = await rootBundle.load("assets/db/words.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, readOnly: true);  // This becomes final in memory
  }
}
