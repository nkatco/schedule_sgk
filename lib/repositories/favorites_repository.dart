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
}
