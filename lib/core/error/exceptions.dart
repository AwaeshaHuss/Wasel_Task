import 'package:equatable/equatable.dart';

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.code, this.stackTrace});

  @override
  String toString() => 'AppException: $message${code != null ? ' ($code)' : ''}';
}

// Server Exceptions
class ServerException extends AppException {
  final int? statusCode;
  final dynamic data;

  const ServerException(
    String message, {
    this.statusCode,
    this.data,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: code ?? 'server-exception',
          stackTrace: stackTrace,
        );
}

// Cache Exceptions
class CacheException extends AppException {
  const CacheException([String message = 'Cache error'])
      : super(message, code: 'cache-exception');
}

// Network Exceptions
class NetworkException extends AppException {
  const NetworkException([String message = 'Network error'])
      : super(message, code: 'network-exception');
}

class NoInternetException extends NetworkException {
  const NoInternetException([String message = 'No internet connection'])
      : super(message);
}

class TimeoutException extends NetworkException {
  const TimeoutException([String message = 'Request timeout'])
      : super(message);
}

// Auth Exceptions
class AuthException extends AppException {
  const AuthException(String message, {String? code, StackTrace? stackTrace})
      : super(
          message,
          code: code ?? 'auth-exception',
          stackTrace: stackTrace,
        );
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException([String message = 'Invalid email'])
      : super(message, code: 'invalid-email');
}

class UserDisabledException extends AuthException {
  const UserDisabledException([String message = 'User disabled'])
      : super(message, code: 'user-disabled');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException([String message = 'User not found'])
      : super(message, code: 'user-not-found');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException([String message = 'Wrong password'])
      : super(message, code: 'wrong-password');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([String message = 'Email already in use'])
      : super(message, code: 'email-already-in-use');
}

class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException(
      [String message = 'Operation not allowed'])
      : super(message, code: 'operation-not-allowed');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException([String message = 'Weak password'])
      : super(message, code: 'weak-password');
}

class RequiresRecentLoginException extends AuthException {
  const RequiresRecentLoginException(
      [String message = 'Requires recent login'])
      : super(message, code: 'requires-recent-login');
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException([String message = 'Too many requests'])
      : super(message, code: 'too-many-requests');
}

class AccountExistsWithDifferentCredentialException extends AuthException {
  const AccountExistsWithDifferentCredentialException(
      [String message = 'Account exists with different credential'])
      : super(message, code: 'account-exists-with-different-credential');
}

class InvalidCredentialException extends AuthException {
  const InvalidCredentialException([String message = 'Invalid credential'])
      : super(message, code: 'invalid-credential');
}

class InvalidVerificationCodeException extends AuthException {
  const InvalidVerificationCodeException(
      [String message = 'Invalid verification code'])
      : super(message, code: 'invalid-verification-code');
}

class InvalidVerificationIdException extends AuthException {
  const InvalidVerificationIdException(
      [String message = 'Invalid verification ID'])
      : super(message, code: 'invalid-verification-id');
}

// Local Storage Exceptions
class LocalStorageException extends AppException {
  const LocalStorageException(String message, {String? code})
      : super(message, code: code ?? 'local-storage-exception');
}

class NotFoundInCacheException extends LocalStorageException {
  const NotFoundInCacheException([String message = 'Not found in cache'])
      : super(message, code: 'not-found-in-cache');
}

// Platform Exceptions
class PlatformException extends AppException {
  const PlatformException(String message, {String? code})
      : super(message, code: code ?? 'platform-exception');
}

// Format Exceptions
class FormatException extends AppException {
  const FormatException(String message, {String? code})
      : super(message, code: code ?? 'format-exception');
}
