class Problem {
  final String title;
  final String description;
  final String location;
  final String date;
  final ProblemStatus status;
  final String? handledBy;
  final String imagePath; 

  Problem({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    this.handledBy,
    required this.imagePath,
  });
}
enum ProblemStatus {
  pending,
  solved,
}