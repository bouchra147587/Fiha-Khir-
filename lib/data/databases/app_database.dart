import 'package:sqflite/sqflite.dart';
import 'db_base.dart';
import 'dbhelper.dart';
import 'db_history.dart';
import '../models/problem_model.dart';
import '../models/user_model.dart';
import '../models/organization_request_model.dart';

/// Main database class that uses DbBase, DbHelper, and DbHistory
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  final DbBase _dbBase = DbBase();
  final DbHelper _dbHelper = DbHelper();
  final DbHistory _dbHistory = DbHistory();

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database => _dbBase.database;

  // Initialize database with dummy data
  Future<void> initialize() async {
    final db = await database;
    // Check if data already exists
    final existingUsers = await db.query('users', limit: 1);
    if (existingUsers.isEmpty) {
      await _insertDummyData(db);
    }
  }

  Future<void> _insertDummyData(Database db) async {
    // Insert dummy users
    await db.insert('users', {
      'id': 'user1',
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'username': 'johndoe',
      'password': 'password123',
      'location': 'Downtown District',
      'memberSince': 'January 2025',
      'problemsReported': 5,
      'problemsSolved': 2,
      'type': UserType.user.name,
      'isVerified': 0,
    });

    await db.insert('users', {
      'id': 'user2',
      'name': 'Sara Mohamed',
      'email': 'sara.mohamed@email.com',
      'username': 'saramohamed',
      'password': 'password123',
      'location': 'Park Avenue',
      'memberSince': 'February 2025',
      'problemsReported': 3,
      'problemsSolved': 0,
      'type': UserType.user.name,
      'isVerified': 0,
    });

    await db.insert('users', {
      'id': 'user3',
      'name': 'Omar Ali',
      'email': 'omar.ali@email.com',
      'username': 'omarali',
      'password': 'password123',
      'location': 'Elm Street',
      'memberSince': 'March 2025',
      'problemsReported': 2,
      'problemsSolved': 1,
      'type': UserType.user.name,
      'isVerified': 0,
    });

    // Insert organization users
    await db.insert('users', {
      'id': 'org1',
      'name': 'City Works Association',
      'email': 'cityworks@email.com',
      'username': 'cityworks',
      'password': 'password123',
      'location': 'City Center',
      'memberSince': 'January 2024',
      'problemsReported': 0,
      'problemsSolved': 45,
      'type': UserType.organization.name,
      'isVerified': 1,
      'organizationDescription': 'Infrastructure repair and maintenance specialists',
      'organizationMembers': 45,
    });

    await db.insert('users', {
      'id': 'org2',
      'name': 'Youth Volunteers Group',
      'email': 'youthvolunteers@email.com',
      'username': 'youthvolunteers',
      'password': 'password123',
      'location': 'Community Center',
      'memberSince': 'June 2024',
      'problemsReported': 0,
      'problemsSolved': 38,
      'type': UserType.organization.name,
      'isVerified': 1,
      'organizationDescription': 'Young people making a difference in the community',
      'organizationMembers': 32,
    });

    await db.insert('users', {
      'id': 'org3',
      'name': 'Green Earth Initiative',
      'email': 'greenearth@email.com',
      'username': 'greenearth',
      'password': 'password123',
      'location': 'Eco Park',
      'memberSince': 'September 2024',
      'problemsReported': 0,
      'problemsSolved': 31,
      'type': UserType.organization.name,
      'isVerified': 1,
      'organizationDescription': 'Environmental conservation and sustainability',
      'organizationMembers': 28,
    });

    // Insert admin user
    await db.insert('users', {
      'id': 'admin1',
      'name': 'Admin User',
      'email': 'admin@fihakhir.com',
      'username': 'admin',
      'password': 'admin123',
      'location': 'Admin Office',
      'memberSince': 'January 2024',
      'problemsReported': 0,
      'problemsSolved': 0,
      'type': UserType.admin.name,
      'isVerified': 1,
    });

    // Additional admin account requested by user
    await db.insert('users', {
      'id': 'admin2',
      'name': 'Kahina Larmed',
      'email': 'kahina.larmed@ensia.edu.dz',
      'username': 'kahina.larmed',
      'password': '123456',
      'location': 'Admin Office',
      'memberSince': DateTime.now().toString().split(' ')[0],
      'problemsReported': 0,
      'problemsSolved': 0,
      'type': UserType.admin.name,
      'isVerified': 1,
    });

    // Insert problems - some approved, some pending approval
    await db.insert('problems', {
      'id': 'prob1',
      'title': 'Garbage Accumulation',
      'description': 'Uncollected waste piling up for over a week. Creating health hazards and unpleasant odors in the neighborhood.',
      'location': 'Park Avenue',
      'date': '2025-01-15',
      'status': ProblemStatus.approved.name,
      'handledBy': null,
      'reportedBy': 'user2',
      'isApproved': 1,
      'beforePhotoPath': 'assets/Images/GarbageAccumulation.jpg',
      'afterPhotoPath': null,
      'rejectionReason': null,
    });

    await db.insert('problems', {
      'id': 'prob2',
      'title': 'Broken Street Light',
      'description': 'Street light has been out for two weeks making the area unsafe at night. Located at the corner of Elm Street.',
      'location': 'Elm Street Corner',
      'date': '2025-01-20',
      'status': ProblemStatus.approved.name,
      'handledBy': null,
      'reportedBy': 'user3',
      'isApproved': 1,
      'beforePhotoPath': 'assets/Images/broken_street_light.jfif',
      'afterPhotoPath': null,
      'rejectionReason': null,
    });

    await db.insert('problems', {
      'id': 'prob3',
      'title': 'Damaged Road on Main Street',
      'description': 'Large pothole causing traffic issues and potential accidents. Located near the shopping district.',
      'location': 'Main Street, Downtown',
      'date': '2025-01-10',
      'status': ProblemStatus.inProgress.name,
      'handledBy': 'org1',
      'reportedBy': 'user1',
      'isApproved': 1,
      'beforePhotoPath': 'assets/Images/damaged_road.jfif',
      'afterPhotoPath': null,
      'rejectionReason': null,
    });

    await db.insert('problems', {
      'id': 'prob4',
      'title': 'Playground Equipment Broken',
      'description': 'Swing set in the public park is broken and dangerous for children. Needs immediate repair.',
      'location': 'Community Park',
      'date': '2025-01-18',
      'status': ProblemStatus.solved.name,
      'handledBy': 'org2',
      'reportedBy': 'user1',
      'isApproved': 1,
      'beforePhotoPath': 'assets/Images/PlaygroundEquipementBroken.png',
      'afterPhotoPath': 'assets/Images/PlaygroundEquipementBroken.png',
      'rejectionReason': null,
    });

    await db.insert('problems', {
      'id': 'prob5',
      'title': 'Overflowing Drainage System',
      'description': 'Drainage system is overflowing during rain, causing flooding on the street.',
      'location': 'River Street',
      'date': '2025-01-22',
      'status': ProblemStatus.pending.name,
      'handledBy': null,
      'reportedBy': 'user2',
      'isApproved': 0,
      'beforePhotoPath': 'assets/Images/damaged_road.jfif',
      'afterPhotoPath': null,
      'rejectionReason': null,
    });

    await db.insert('problems', {
      'id': 'prob6',
      'title': 'Vandalized Public Bench',
      'description': 'Public bench has been vandalized with graffiti and is damaged.',
      'location': 'Central Square',
      'date': '2025-01-21',
      'status': ProblemStatus.pending.name,
      'handledBy': null,
      'reportedBy': 'user3',
      'isApproved': 0,
      'beforePhotoPath': 'assets/Images/BrokenStreetLight.png',
      'afterPhotoPath': null,
      'rejectionReason': null,
    });

    // Insert organization requests - pending approval
    await db.insert('organization_requests', {
      'id': 'org_req1',
      'name': 'Community Care Network',
      'description': 'Supporting vulnerable members of our community',
      'email': 'communitycare@email.com',
      'contactPerson': 'Ahmed Hassan',
      'status': OrganizationRequestStatus.pending.name,
      'rejectionReason': null,
      'requestedDate': '2025-01-15',
    });

    await db.insert('organization_requests', {
      'id': 'org_req2',
      'name': 'Parks & Recreation Volunteers',
      'description': 'Maintaining and improving public parks and recreational areas',
      'email': 'parksrec@email.com',
      'contactPerson': 'Fatima Al-Zahra',
      'status': OrganizationRequestStatus.pending.name,
      'rejectionReason': null,
      'requestedDate': '2025-01-18',
    });
  }

  // ============ USER METHODS ============
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users', orderBy: 'memberSince DESC');
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    final result = await db.insert('users', user);
    await _dbHistory.logAction(
      action: 'CREATE_USER',
      entityType: 'user',
      entityId: user['id'] as String,
      userId: user['id'] as String?,
      details: 'User created: ${user['name']}',
    );
    return result;
  }

  Future<int> updateUser(String id, Map<String, dynamic> updates) async {
    final db = await database;
    final result = await db.update('users', updates, where: 'id = ?', whereArgs: [id]);
    await _dbHistory.logAction(
      action: 'UPDATE_USER',
      entityType: 'user',
      entityId: id,
      userId: id,
      details: 'User updated',
    );
    return result;
  }

  // ============ PROBLEM METHODS ============
  Future<List<Map<String, dynamic>>> getAllProblems() async {
    return await _dbHelper.database.then((db) => db.query('problems', orderBy: 'date DESC'));
  }

  Future<List<Map<String, dynamic>>> getApprovedProblems() async {
    return await _dbHelper.getApprovedProblems();
  }

  Future<List<Map<String, dynamic>>> getPendingProblems() async {
    return await _dbHelper.getPendingApprovalProblems();
  }

  Future<Map<String, dynamic>?> getProblemById(String id) async {
    final db = await database;
    final results = await db.query(
      'problems',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> insertProblem(Map<String, dynamic> problem) async {
    final db = await database;
    final result = await db.insert('problems', problem);
    await _dbHistory.logAction(
      action: 'CREATE_PROBLEM',
      entityType: 'problem',
      entityId: problem['id'] as String,
      userId: problem['reportedBy'] as String?,
      details: 'Problem reported: ${problem['title']}',
    );
    return result;
  }

  Future<int> updateProblem(String id, Map<String, dynamic> updates) async {
    final db = await database;
    final result = await db.update('problems', updates, where: 'id = ?', whereArgs: [id]);
    await _dbHistory.logAction(
      action: 'UPDATE_PROBLEM',
      entityType: 'problem',
      entityId: id,
      details: 'Problem updated',
    );
    return result;
  }

  Future<int> approveProblem(String id) async {
    final result = await updateProblem(id, {
      'isApproved': 1,
      'status': ProblemStatus.approved.name,
    });
    await _dbHistory.logAction(
      action: 'APPROVE_PROBLEM',
      entityType: 'problem',
      entityId: id,
      details: 'Problem approved by admin',
    );
    return result;
  }

  Future<int> rejectProblem(String id, String reason) async {
    final result = await updateProblem(id, {
      'isApproved': 0,
      'status': ProblemStatus.rejected.name,
      'rejectionReason': reason,
    });
    await _dbHistory.logAction(
      action: 'REJECT_PROBLEM',
      entityType: 'problem',
      entityId: id,
      details: 'Problem rejected: $reason',
    );
    return result;
  }

  Future<int> updateProblemStatus(String id, ProblemStatus status, {String? handledBy, String? afterPhotoPath}) async {
    final updates = <String, dynamic>{'status': status.name};
    if (handledBy != null) updates['handledBy'] = handledBy;
    if (afterPhotoPath != null) updates['afterPhotoPath'] = afterPhotoPath;
    final result = await updateProblem(id, updates);
    await _dbHistory.logAction(
      action: 'UPDATE_PROBLEM_STATUS',
      entityType: 'problem',
      entityId: id,
      userId: handledBy,
      details: 'Status changed to ${status.name}',
    );
    return result;
  }

  // ============ ORGANIZATION REQUEST METHODS ============
  Future<List<Map<String, dynamic>>> getAllOrganizationRequests() async {
    final db = await database;
    return await db.query('organization_requests', orderBy: 'requestedDate DESC');
  }

  Future<List<Map<String, dynamic>>> getPendingOrganizationRequests() async {
    return await _dbHelper.getPendingOrganizationRequests();
  }

  Future<Map<String, dynamic>?> getOrganizationRequestById(String id) async {
    final db = await database;
    final results = await db.query(
      'organization_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> insertOrganizationRequest(Map<String, dynamic> request) async {
    final db = await database;
    final result = await db.insert('organization_requests', request);
    await _dbHistory.logAction(
      action: 'CREATE_ORG_REQUEST',
      entityType: 'organization_request',
      entityId: request['id'] as String,
      details: 'Organization request created: ${request['name']}',
    );
    return result;
  }

  Future<int> approveOrganizationRequest(String id) async {
    final db = await database;
    final request = await getOrganizationRequestById(id);
    if (request == null) return 0;

    // Create user account from approved request
    if (request['username'] != null && request['password'] != null) {
      await insertUser({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': request['name'],
        'email': request['email'],
        'username': request['username'],
        'password': request['password'],
        'location': request['location'] ?? 'Unknown',
        'memberSince': DateTime.now().toString().split(' ')[0],
        'problemsReported': 0,
        'problemsSolved': 0,
        'type': UserType.organization.name,
        'isVerified': 1,
        'organizationDescription': request['organizationDescription'],
        'organizationMembers': request['organizationMembers'],
      });
    }

    final result = await db.update(
      'organization_requests',
      {'status': OrganizationRequestStatus.approved.name},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _dbHistory.logAction(
      action: 'APPROVE_ORG_REQUEST',
      entityType: 'organization_request',
      entityId: id,
      details: 'Organization request approved: ${request['name']}',
    );
    return result;
  }

  Future<int> rejectOrganizationRequest(String id, String reason) async {
    final db = await database;
    final result = await db.update(
      'organization_requests',
      {
        'status': OrganizationRequestStatus.rejected.name,
        'rejectionReason': reason,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await _dbHistory.logAction(
      action: 'REJECT_ORG_REQUEST',
      entityType: 'organization_request',
      entityId: id,
      details: 'Organization request rejected: $reason',
    );
    return result;
  }

  // ============ STATISTICS METHODS ============
  Future<Map<String, int>> getAdminStatistics() async {
    return {
      'totalProblems': await _dbHelper.getTotalProblemsCount(),
      'solvedProblems': await _dbHelper.getSolvedProblemsCount(),
      'pendingProblems': await _dbHelper.getPendingProblemsCount(),
      'organizations': await _dbHelper.getOrganizationsCount(),
      'pendingOrgRequests': await _dbHelper.getPendingOrgRequestsCount(),
    };
  }

  // Expose helper and history for direct access if needed
  DbHelper get helper => _dbHelper;
  DbHistory get history => _dbHistory;
}
