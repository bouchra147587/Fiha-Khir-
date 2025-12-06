import 'package:equatable/equatable.dart';
import '../../../data/models/problem_model.dart';

abstract class ProblemState extends Equatable {
  const ProblemState();

  @override
  List<Object?> get props => [];
}

class ProblemInitial extends ProblemState {}

class ProblemLoading extends ProblemState {}

class ProblemLoaded extends ProblemState {
  final List<Problem> problems;

  const ProblemLoaded(this.problems);

  @override
  List<Object?> get props => [problems];
}

class ProblemError extends ProblemState {
  final String message;

  const ProblemError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProblemAdded extends ProblemState {
  final Problem problem;

  const ProblemAdded(this.problem);

  @override
  List<Object?> get props => [problem];
}


