import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthLoggedIn extends AuthState {
  final User user;
  AuthLoggedIn(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signup(User user) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save user info (for demo, we only allow 1 user)
      await prefs.setStringList('user', [
        user.name,
        user.phone,
        user.email,
        user.password,
        user.role
      ]);
      emit(AuthLoggedIn(user));
    } catch (e) {
      emit(AuthError('Failed to sign up'));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('user');
      if (data == null) {
        emit(AuthError('No user found. Please sign up first.'));
        return;
      }
      final user = User(
        name: data[0],
        phone: data[1],
        email: data[2],
        password: data[3],
        role: data[4],
      );

      if (email == user.email && password == user.password) {
        emit(AuthLoggedIn(user));
      } else {
        emit(AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError('Login failed'));
    }
  }

  Future<void> logout() async {
    emit(AuthInitial());
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('user');
    if (data != null) {
      return User(
        name: data[0],
        phone: data[1],
        email: data[2],
        password: data[3],
        role: data[4],
      );
    }
    return null;
  }
}
