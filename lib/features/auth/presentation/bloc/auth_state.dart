import 'package:equatable/equatable.dart';
import 'package:wasel_task/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordResetEmailSent extends AuthState {}

class ProfileUpdated extends AuthState {
  final UserEntity user;

  const ProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class AccountDeleted extends AuthState {}
