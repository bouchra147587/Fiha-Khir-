import 'package:sqflite/sqflite.dart';
import 'db_base.dart';
import '../models/problem_model.dart';
import '../models/user_model.dart';
import '../models/organization_request_model.dart';

/// Database helper methods for common operations
class DbHelper {
  final DbBase _dbBase = DbBase();

  Future<Database> get database => _dbBase.database;

  // ============ USER HELPERS ============
  
  /// Check if email exists
  Future<bool> emailExists(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }

  /// Check if username exists
  Future<bool> usernameExists(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }

  /// Get users by type
  Future<List<Map<String, dynamic>>> getUsersByType(UserType type) async {
    final db = await database;
    return await db.query(
      'users',
      where: 'type = ?',
      whereArgs: [type.name],
      orderBy: 'memberSince DESC',
    );
  }

  /// Get verified organizations
  Future<List<Map<String, dynamic>>> getVerifiedOrganizations() async {
    final db = await database;
    return await db.query(
      'users',
      where: 'type = ? AND isVerified = ?',
      whereArgs: [UserType.organization.name, 1],
      orderBy: 'memberSince DESC',
    );
  }

  // ============ PROBLEM HELPERS ============
  
  /// Get problems by status
  Future<List<Map<String, dynamic>>> getProblemsByStatus(ProblemStatus status) async {
    final db = await database;
    return await db.query(
      'problems',
      where: 'status = ?',
      whereArgs: [status.name],
      orderBy: 'date DESC',
    );
  }

  /// Get problems reported by a user
  Future<List<Map<String, dynamic>>> getProblemsByReporter(String userId) async {
    final db = await database;
    return await db.query(
      'problems',
      where: 'reportedBy = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  /// Get problems handled by an organization
  Future<List<Map<String, dynamic>>> getProblemsByHandler(String handlerId) async {
    final db = await database;
    return await db.query(
      'problems',
      where: 'handledBy = ?',
      whereArgs: [handlerId],
      orderBy: 'date DESC',
    );
  }

  /// Get pending problems awaiting approval
  Future<List<Map<String, dynamic>>> getPendingApprovalProblems() async {
    final db = await database;
    return await db.query(
      'problems',
      where: 'isApproved = ? AND status = ?',
      whereArgs: [0, ProblemStatus.pending.name],
      orderBy: 'date DESC',
    );
  }

  /// Get approved problems visible to all users
  Future<List<Map<String, dynamic>>> getApprovedProblems() async {
    final db = await database;
    return await db.query(
      'problems',
      where: 'isApproved = ?',
      whereArgs: [1],
      orderBy: 'date DESC',
    );
  }

  // ============ ORGANIZATION REQUEST HELPERS ============
  
  /// Get pending organization requests
  Future<List<Map<String, dynamic>>> getPendingOrganizationRequests() async {
    final db = await database;
    return await db.query(
      'organization_requests',
      where: 'status = ?',
      whereArgs: [OrganizationRequestStatus.pending.name],
      orderBy: 'requestedDate DESC',
    );
  }

  /// Check if organization email already exists in requests
  Future<bool> organizationRequestExists(String email) async {
    final db = await database;
    final results = await db.query(
      'organization_requests',
      where: 'email = ? AND status = ?',
      whereArgs: [email, OrganizationRequestStatus.pending.name],
    );
    return results.isNotEmpty;
  }

  // ============ STATISTICS HELPERS ============
  
  /// Get total count of problems
  Future<int> getTotalProblemsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM problems');
    return result.first['count'] as int;
  }

  /// Get solved problems count
  Future<int> getSolvedProblemsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM problems WHERE status = ?',
      [ProblemStatus.solved.name],
    );
    return result.first['count'] as int;
  }

  /// Get pending problems count
  Future<int> getPendingProblemsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM problems WHERE isApproved = 0 AND status = ?',
      [ProblemStatus.pending.name],
    );
    return result.first['count'] as int;
  }

  /// Get organizations count
  Future<int> getOrganizationsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM users WHERE type = ?',
      [UserType.organization.name],
    );
    return result.first['count'] as int;
  }

  /// Get pending organization requests count
  Future<int> getPendingOrgRequestsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM organization_requests WHERE status = ?',
      [OrganizationRequestStatus.pending.name],
    );
    return result.first['count'] as int;
  }

  /// Calculate problem resolution rate
  Future<double> getProblemResolutionRate() async {
    final total = await getTotalProblemsCount();
    if (total == 0) return 0.0;
    final solved = await getSolvedProblemsCount();
    return (solved / total) * 100;
  }

  /// Get verified organizations percentage
  Future<double> getVerifiedOrganizationsPercentage() async {
    final total = await getOrganizationsCount();
    if (total == 0) return 0.0;
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM users WHERE type = ? AND isVerified = ?',
      [UserType.organization.name, 1],
    );
    final verified = result.first['count'] as int;
    return (verified / total) * 100;
  }

  /// Get active problems percentage (in progress)
  Future<double> getActiveProblemsPercentage() async {
    final total = await getTotalProblemsCount();
    if (total == 0) return 0.0;
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM problems WHERE status = ?',
      [ProblemStatus.inProgress.name],
    );
    final active = result.first['count'] as int;
    return (active / total) * 100;
  }
}


