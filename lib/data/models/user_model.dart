import 'package:equatable/equatable.dart';

enum UserType {
  user(0),          // Regular citizen
  organization(1),  // Organization/Volunteer group
  admin(2);         // Admin user

  final int code;
  const UserType(this.code);

  static UserType fromCode(int code) {
    return UserType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => UserType.user,
    );
  }
}

class User extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String username;
  final String password; // Hashed password in real app
  final String location;
  final String memberSince;
  final int problemsReported;
  final int problemsSolved;
  final UserType type;
  final bool isVerified; // For organizations
  final String? organizationDescription; // For organizations
  final int? organizationMembers; // For organizations

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.location,
    required this.memberSince,
    this.problemsReported = 0,
    this.problemsSolved = 0,
    this.type = UserType.user,
    this.isVerified = false,
    this.organizationDescription,
    this.organizationMembers,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? password,
    String? location,
    String? memberSince,
    int? problemsReported,
    int? problemsSolved,
    UserType? type,
    bool? isVerified,
    String? organizationDescription,
    int? organizationMembers,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      location: location ?? this.location,
      memberSince: memberSince ?? this.memberSince,
      problemsReported: problemsReported ?? this.problemsReported,
      problemsSolved: problemsSolved ?? this.problemsSolved,
      type: type ?? this.type,
      isVerified: isVerified ?? this.isVerified,
      organizationDescription: organizationDescription ?? this.organizationDescription,
      organizationMembers: organizationMembers ?? this.organizationMembers,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        username,
        password,
        location,
        memberSince,
        problemsReported,
        problemsSolved,
        type,
        isVerified,
        organizationDescription,
        organizationMembers,
      ];
}
