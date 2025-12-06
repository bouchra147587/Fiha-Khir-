import '../databases/app_database.dart';
import '../models/organization_request_model.dart';

class OrganizationRequestRepository {
  final AppDatabase _database = AppDatabase();

  Future<List<OrganizationRequest>> getAllRequests() async {
    final data = await _database.getAllOrganizationRequests();
    return data.map((map) => _mapToRequest(map)).toList();
  }

  Future<List<OrganizationRequest>> getPendingRequests() async {
    final data = await _database.getPendingOrganizationRequests();
    return data.map((map) => _mapToRequest(map)).toList();
  }

  Future<OrganizationRequest?> getRequestById(String id) async {
    final data = await _database.getOrganizationRequestById(id);
    return data != null ? _mapToRequest(data) : null;
  }

  Future<void> addRequest(OrganizationRequest request) async {
    await _database.insertOrganizationRequest({
      'id': request.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'name': request.name,
      'description': request.description,
      'email': request.email,
      'contactPerson': request.contactPerson,
      'status': request.status.name,
      'rejectionReason': request.rejectionReason,
      'requestedDate': request.requestedDate,
      'username': request.username,
      'password': request.password,
      'location': request.location,
      'organizationDescription': request.organizationDescription,
      'organizationMembers': request.organizationMembers,
    });
  }

  Future<void> approveRequest(String id) async {
    await _database.approveOrganizationRequest(id);
  }

  Future<void> rejectRequest(String id, String reason) async {
    await _database.rejectOrganizationRequest(id, reason);
  }

  OrganizationRequest _mapToRequest(Map<String, dynamic> map) {
    return OrganizationRequest(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      email: map['email'] as String,
      contactPerson: map['contactPerson'] as String,
      status: OrganizationRequestStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrganizationRequestStatus.pending,
      ),
      rejectionReason: map['rejectionReason'] as String?,
      requestedDate: map['requestedDate'] as String,
      username: map['username'] as String?,
      password: map['password'] as String?,
      location: map['location'] as String?,
      organizationDescription: map['organizationDescription'] as String?,
      organizationMembers: map['organizationMembers'] as int?,
    );
  }
}


