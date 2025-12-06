import '../databases/app_database.dart';
import '../models/problem_model.dart';

class ProblemRepository {
  final AppDatabase _database = AppDatabase();

  Future<List<Problem>> getAllProblems() async {
    final data = await _database.getAllProblems();
    return data.map((map) => _mapToProblem(map)).toList();
  }

  Future<List<Problem>> getApprovedProblems() async {
    final data = await _database.getApprovedProblems();
    return data.map((map) => _mapToProblem(map)).toList();
  }

  Future<List<Problem>> getPendingProblems() async {
    final data = await _database.getPendingProblems();
    return data.map((map) => _mapToProblem(map)).toList();
  }

  Future<Problem?> getProblemById(String id) async {
    final data = await _database.getProblemById(id);
    return data != null ? _mapToProblem(data) : null;
  }

  Future<void> addProblem(Problem problem) async {
    await _database.insertProblem({
      'id': problem.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': problem.title,
      'description': problem.description,
      'location': problem.location,
      'date': problem.date,
      'status': problem.status.name,
      'handledBy': problem.handledBy,
      'reportedBy': problem.reportedBy,
      'isApproved': problem.isApproved ? 1 : 0,
      'beforePhotoPath': problem.beforePhotoPath,
      'afterPhotoPath': problem.afterPhotoPath,
      'rejectionReason': problem.rejectionReason,
    });
  }

  Future<void> approveProblem(String id) async {
    await _database.approveProblem(id);
  }

  Future<void> rejectProblem(String id, String reason) async {
    await _database.rejectProblem(id, reason);
  }

  Future<void> updateProblemStatus(
    String id,
    ProblemStatus status, {
    String? handledBy,
    String? afterPhotoPath,
  }) async {
    await _database.updateProblemStatus(id, status, handledBy: handledBy, afterPhotoPath: afterPhotoPath);
  }

  Problem _mapToProblem(Map<String, dynamic> map) {
    return Problem(
      id: map['id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      date: map['date'] as String,
      status: ProblemStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ProblemStatus.pending,
      ),
      handledBy: map['handledBy'] as String?,
      reportedBy: map['reportedBy'] as String?,
      isApproved: (map['isApproved'] as int) == 1,
      beforePhotoPath: map['beforePhotoPath'] as String?,
      afterPhotoPath: map['afterPhotoPath'] as String?,
      rejectionReason: map['rejectionReason'] as String?,
    );
  }
}
