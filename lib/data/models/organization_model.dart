import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String? id;
  final String name;
  final String description;
  final int members;
  final int solved;
  final bool isVerified;
  final String? userId; // Link to user account

  const Organization({
    this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.solved,
    required this.isVerified,
    this.userId,
  });

  Organization copyWith({
    String? id,
    String? name,
    String? description,
    int? members,
    int? solved,
    bool? isVerified,
    String? userId,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      solved: solved ?? this.solved,
      isVerified: isVerified ?? this.isVerified,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, name, description, members, solved, isVerified, userId];
}
