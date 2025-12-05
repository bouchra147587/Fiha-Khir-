import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// -----------------
/// Auth States
/// -----------------
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

/// -----------------
/// Auth Cubit
/// -----------------
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  /// Signup user and save to SharedPreferences
  Future<void> signup(User user) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save user info including location and birthDay
      await prefs.setStringList('user', [
        user.name,
        user.phone,
        user.email,
        user.password,
        user.role,
        user.location,
        user.birthDay,
      ]);

      emit(AuthLoggedIn(user));
    } catch (e) {
      emit(AuthError('Failed to sign up: $e'));
    }
  }

  /// Login using email & password
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
        email: data[2],
        phone: data[1],
        role: data[4],
        password: data[3],
        location: data.length > 5 ? data[5] : '',
        birthDay: data.length > 6 ? data[6] : '',
      );

      if (email == user.email && password == user.password) {
        emit(AuthLoggedIn(user));
      } else {
        emit(AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  /// Logout user
  Future<void> logout() async {
    emit(AuthInitial());
  }

  /// Get current user from SharedPreferences
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('user');

    if (data != null) {
      return User(
        name: data[0],
        email: data[2],
        phone: data[1],
        role: data[4],
        password: data[3],
        location: data.length > 5 ? data[5] : '',
        birthDay: data.length > 6 ? data[6] : '',
      );
    }
    return null;
  }
}
