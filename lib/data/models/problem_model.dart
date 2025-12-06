import 'package:equatable/equatable.dart';

enum ProblemStatus {
  pending(0),      // Waiting for admin approval
  approved(1),     // Approved by admin, waiting for action
  inProgress(2),   // Being handled by organization/volunteer
  solved(3),       // Completed
  rejected(4);     // Rejected by admin

  final int code;
  const ProblemStatus(this.code);

  static ProblemStatus fromCode(int code) {
    return ProblemStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ProblemStatus.pending,
    );
  }
}

class Problem extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String location;
  final String date;
  final ProblemStatus status;
  final String? handledBy; // Organization/User ID who is handling it
  final String? reportedBy; // User ID who reported it
  final bool isApproved; // Admin approval status
  final String? beforePhotoPath; // Initial photo
  final String? afterPhotoPath; // Completion photo
  final String? rejectionReason; // If rejected by admin

  const Problem({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    this.handledBy,
    this.reportedBy,
    this.isApproved = false,
    this.beforePhotoPath,
    this.afterPhotoPath,
    this.rejectionReason,
  });

  Problem copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? date,
    ProblemStatus? status,
    String? handledBy,
    String? reportedBy,
    bool? isApproved,
    String? beforePhotoPath,
    String? afterPhotoPath,
    String? rejectionReason,
  }) {
    return Problem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      status: status ?? this.status,
      handledBy: handledBy ?? this.handledBy,
      reportedBy: reportedBy ?? this.reportedBy,
      isApproved: isApproved ?? this.isApproved,
      beforePhotoPath: beforePhotoPath ?? this.beforePhotoPath,
      afterPhotoPath: afterPhotoPath ?? this.afterPhotoPath,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        date,
        status,
        handledBy,
        reportedBy,
        isApproved,
        beforePhotoPath,
        afterPhotoPath,
        rejectionReason,
      ];
}
