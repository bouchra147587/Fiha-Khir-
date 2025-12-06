import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository = UserRepository();

  AuthCubit() : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        emit(AuthAuthenticated(user));
        return;
      }
    }
    emit(AuthUnauthenticated());
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.id!);
        await prefs.setBool('isAuthenticated', true);
        emit(AuthAuthenticated(user));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.setBool('isAuthenticated', false);
    emit(AuthUnauthenticated());
  }

  User? getCurrentUser() {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user;
    }
    return null;
  }
}


