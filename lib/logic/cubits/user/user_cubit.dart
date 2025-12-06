import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial()) {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    emit(UserLoading());
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError('User not found'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}


