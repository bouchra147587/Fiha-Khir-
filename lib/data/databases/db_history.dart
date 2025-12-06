import 'db_base.dart';

/// Database history/audit log functionality
class DbHistory {
  final DbBase _dbBase = DbBase();

  /// Log an action to the history table
  Future<int> logAction({
    required String action,
    required String entityType,
    required String entityId,
    String? userId,
    String? details,
  }) async {
    final db = await _dbBase.database;
    return await db.insert('history', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'userId': userId,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Get history for a specific entity
  Future<List<Map<String, dynamic>>> getEntityHistory(String entityType, String entityId) async {
    final db = await _dbBase.database;
    return await db.query(
      'history',
      where: 'entityType = ? AND entityId = ?',
      whereArgs: [entityType, entityId],
      orderBy: 'timestamp DESC',
    );
  }

  /// Get all history records
  Future<List<Map<String, dynamic>>> getAllHistory({int? limit}) async {
    final db = await _dbBase.database;
    return await db.query(
      'history',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  /// Get history by user
  Future<List<Map<String, dynamic>>> getUserHistory(String userId) async {
    final db = await _dbBase.database;
    return await db.query(
      'history',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
  }

  /// Clear old history records (older than specified days)
  Future<int> clearOldHistory(int daysOld) async {
    final db = await _dbBase.database;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    return await db.delete(
      'history',
      where: 'timestamp < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );
  }
}

