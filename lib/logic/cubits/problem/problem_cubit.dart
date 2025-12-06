import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/problem_repository.dart';
import '../../../data/models/problem_model.dart';
import 'problem_state.dart';

class ProblemCubit extends Cubit<ProblemState> {
  final ProblemRepository _repository;

  ProblemCubit(this._repository) : super(ProblemInitial()) {
    loadProblems();
  }

  Future<void> loadProblems() async {
    emit(ProblemLoading());
    try {
      // Only load approved problems for regular users
      final problems = await _repository.getApprovedProblems();
      emit(ProblemLoaded(problems));
    } catch (e) {
      emit(ProblemError(e.toString()));
    }
  }

  Future<void> addProblem(Problem problem) async {
    try {
      await _repository.addProblem(problem);
      emit(ProblemAdded(problem));
      // Wait a moment for database to update, then reload
      await Future.delayed(const Duration(milliseconds: 500));
      loadProblems(); // Reload to update list
    } catch (e) {
      emit(ProblemError(e.toString()));
    }
  }

  Future<void> refreshProblems() async {
    emit(ProblemLoading());
    try {
      final problems = await _repository.getApprovedProblems();
      emit(ProblemLoaded(problems));
    } catch (e) {
      emit(ProblemError(e.toString()));
    }
  }
}


