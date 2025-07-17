import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error']) : super(message);
}

// Auth failures
class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure([String message = 'Invalid email'])
      : super(message, code: 'invalid-email');
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure([String message = 'User disabled'])
      : super(message, code: 'user-disabled');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([String message = 'User not found'])
      : super(message, code: 'user-not-found');
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure([String message = 'Wrong password'])
      : super(message, code: 'wrong-password');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure([String message = 'Email already in use'])
      : super(message, code: 'email-already-in-use');
}

class OperationNotAllowedFailure extends Failure {
  const OperationNotAllowedFailure(
      [String message = 'Operation not allowed'])
      : super(message, code: 'operation-not-allowed');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure([String message = 'Weak password'])
      : super(message, code: 'weak-password');
}

class RequiresRecentLoginFailure extends Failure {
  const RequiresRecentLoginFailure(
      [String message = 'Requires recent login'])
      : super(message, code: 'requires-recent-login');
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure([String message = 'Too many requests'])
      : super(message, code: 'too-many-requests');
}

class AccountExistsWithDifferentCredentialFailure extends Failure {
  const AccountExistsWithDifferentCredentialFailure(
      [String message = 'Account exists with different credential'])
      : super(message, code: 'account-exists-with-different-credential');
}

class InvalidCredentialFailure extends Failure {
  const InvalidCredentialFailure([String message = 'Invalid credential'])
      : super(message, code: 'invalid-credential');
}

class InvalidVerificationCodeFailure extends Failure {
  const InvalidVerificationCodeFailure(
      [String message = 'Invalid verification code'])
      : super(message, code: 'invalid-verification-code');
}

class InvalidVerificationIdFailure extends Failure {
  const InvalidVerificationIdFailure(
      [String message = 'Invalid verification ID'])
      : super(message, code: 'invalid-verification-id');
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure([String message = 'User is not authenticated'])
      : super(message, code: 'unauthenticated');
}

class CanceledAuthFailure extends Failure {
  const CanceledAuthFailure([String message = 'Authentication was canceled'])
      : super(message, code: 'canceled-auth');
}
