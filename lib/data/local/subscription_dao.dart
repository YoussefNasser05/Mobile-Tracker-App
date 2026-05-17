import 'package:sqflite/sqflite.dart';
import '../../models/subscription_model.dart';
import 'database_helper.dart';

class SubscriptionDao {
  final _db = DatabaseHelper.instance;

  Future<List<Subscription>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('subscriptions', where: 'isActive = 1');
    return maps.map(Subscription.fromMap).toList();
  }

  Future<void> insert(Subscription sub) async {
    final db = await _db.database;
    await db.insert('subscriptions', sub.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Subscription sub) async {
    final db = await _db.database;
    await db.update('subscriptions', sub.toMap(),
        where: 'id = ?', whereArgs: [sub.id]);
  }

  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.delete('subscriptions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> upsertAll(List<Subscription> subs) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final s in subs) {
      batch.insert('subscriptions', s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
