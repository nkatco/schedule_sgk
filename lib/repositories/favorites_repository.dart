import 'package:schedule_sgk/models/item.dart';
import 'package:schedule_sgk/repositories/cabinet_repository.dart';
import 'package:schedule_sgk/repositories/group_repository.dart';
import 'package:schedule_sgk/repositories/teacher_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../services/database_provider.dart';

class FavoritesRepository {
  Future<void> insertFavorite(String key) async {
    final db = await DatabaseProvider.instance.database;

    await db.insert(
      'Favorites',
      {'key': key},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(String key) async {
    final db = await DatabaseProvider.instance.database;

    await db.delete(
      'Favorites',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<bool> isKeyRegistered(String key) async {
    final db = await DatabaseProvider.instance.database;

    List<Map<String, dynamic>> result = await db.query(
      'Favorites',
      where: 'key = ?',
      whereArgs: [key],
    );

    return result.isNotEmpty;
  }

  Future<List<String>> getAllKeys() async {
    final db = await DatabaseProvider.instance.database;

    List<Map<String, dynamic>> result = await db.query('Favorites');

    List<String> keys = result.map((entry) => entry['key'].toString()).toList();

    return keys;
  }
}
