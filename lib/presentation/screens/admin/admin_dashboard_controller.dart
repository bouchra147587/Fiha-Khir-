import '../../../data/models/problem_model.dart';
import '../../../data/models/organization_request_model.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/repositories/problem_repository.dart';
import '../../../data/repositories/organization_request_repository.dart';

class AdminDashboardController {
  final AdminRepository _adminRepository = AdminRepository();
  final ProblemRepository _problemRepository = ProblemRepository();
  final OrganizationRequestRepository _orgRequestRepository = OrganizationRequestRepository();

  Future<Map<String, int>> getStatistics() async {
    return await _adminRepository.getStatistics();
  }

  Future<List<Problem>> getPendingProblems() async {
    return await _problemRepository.getPendingProblems();
  }

  Future<List<OrganizationRequest>> getPendingOrgRequests() async {
    return await _orgRequestRepository.getPendingRequests();
  }

  Future<void> approveProblem(String problemId) async {
    await _problemRepository.approveProblem(problemId);
  }

  Future<void> rejectProblem(String problemId, String reason) async {
    await _problemRepository.rejectProblem(problemId, reason);
  }

  Future<void> approveOrgRequest(String requestId) async {
    await _orgRequestRepository.approveRequest(requestId);
  }

  Future<void> rejectOrgRequest(String requestId, String reason) async {
    await _orgRequestRepository.rejectRequest(requestId, reason);
  }
}

