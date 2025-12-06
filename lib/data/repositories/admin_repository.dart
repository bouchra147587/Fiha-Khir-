import '../databases/app_database.dart';

class AdminRepository {
  final AppDatabase _database = AppDatabase();

  Future<Map<String, int>> getStatistics() async {
    return await _database.getAdminStatistics();
  }
}


