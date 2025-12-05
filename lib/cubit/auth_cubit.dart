import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../models/user_model.dart';
import '../database/db_helper.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signup(User user) async {
    emit(AuthLoading());
    final success = await DatabaseHelper().insertUser(user);
    if (success > 0) {
      emit(AuthLoggedIn(user));
    } else {
      emit(const AuthError("Signup failed. Email may already exist."));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final user = await DatabaseHelper().getUser(email, password);
    if (user != null) {
      emit(AuthLoggedIn(user));
    } else {
      emit(const AuthError("Login failed. Check email/password."));
    }
  }
}
