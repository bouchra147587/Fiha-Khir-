import 'package:equatable/equatable.dart';

enum OrganizationRequestStatus {
  pending(0),
  approved(1),
  rejected(2);

  final int code;
  const OrganizationRequestStatus(this.code);

  static OrganizationRequestStatus fromCode(int code) {
    return OrganizationRequestStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => OrganizationRequestStatus.pending,
    );
  }
}

class OrganizationRequest extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String email;
  final String contactPerson;
  final OrganizationRequestStatus status;
  final String? rejectionReason;
  final String requestedDate;
  final String? username;
  final String? password;
  final String? location;
  final String? organizationDescription;
  final int? organizationMembers;

  const OrganizationRequest({
    this.id,
    required this.name,
    required this.description,
    required this.email,
    required this.contactPerson,
    required this.status,
    this.rejectionReason,
    required this.requestedDate,
    this.username,
    this.password,
    this.location,
    this.organizationDescription,
    this.organizationMembers,
  });

  OrganizationRequest copyWith({
    String? id,
    String? name,
    String? description,
    String? email,
    String? contactPerson,
    OrganizationRequestStatus? status,
    String? rejectionReason,
    String? requestedDate,
    String? username,
    String? password,
    String? location,
    String? organizationDescription,
    int? organizationMembers,
  }) {
    return OrganizationRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      contactPerson: contactPerson ?? this.contactPerson,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requestedDate: requestedDate ?? this.requestedDate,
      username: username ?? this.username,
      password: password ?? this.password,
      location: location ?? this.location,
      organizationDescription: organizationDescription ?? this.organizationDescription,
      organizationMembers: organizationMembers ?? this.organizationMembers,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        email,
        contactPerson,
        status,
        rejectionReason,
        requestedDate,
        username,
        password,
        location,
        organizationDescription,
        organizationMembers,
      ];
}


