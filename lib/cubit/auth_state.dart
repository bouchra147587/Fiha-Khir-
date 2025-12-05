import '../models/user_model.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoggedIn extends AuthState {
  final User user;
  const AuthLoggedIn(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
