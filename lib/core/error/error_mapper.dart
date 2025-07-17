import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  static Failure mapExceptionToFailure(dynamic exception) {
    if (exception is AppException) {
      return _mapAppExceptionToFailure(exception);
    } else if (exception is DioException) {
      return _mapDioExceptionToFailure(exception);
    } else if (exception is FormatException) {
      return const FormatFailure('Invalid format');
    } else {
      return const ServerFailure('An unexpected error occurred');
    }
  }

  static Failure _mapAppExceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is AuthException) {
      return _mapAuthExceptionToFailure(exception);
    } else if (exception is LocalStorageException) {
      return CacheFailure(exception.message);
    } else {
      return ServerFailure(exception.message);
    }
  }

  static Failure _mapDioExceptionToFailure(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Request timeout');
      case DioExceptionType.badResponse:
        return _handleResponseError(exception);
      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');
      case DioExceptionType.unknown:
        if (exception.error is FormatException) {
          return const FormatFailure('Invalid format');
        } else if (exception.error is NetworkException) {
          return const NetworkFailure();
        }
        return const NetworkFailure('No internet connection');
      default:
        return const ServerFailure('Something went wrong');
    }
  }

  static Failure _handleResponseError(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;
    final message = data is Map ? data['message']?.toString() ?? 'Something went wrong' : 'Something went wrong';
    
    switch (statusCode) {
      case 400:
        return ServerFailure('Bad Request: $message');
      case 401:
        return const UnauthenticatedFailure();
      case 403:
        return const ServerFailure('Forbidden');
      case 404:
        return const ServerFailure('Not Found');
      case 408:
        return const NetworkFailure('Request timeout');
      case 422:
        return ServerFailure('Validation Error: $message');
      case 429:
        return const TooManyRequestsFailure();
      case 500:
        return const ServerFailure('Internal Server Error');
      case 502:
        return const ServerFailure('Bad Gateway');
      case 503:
        return const ServerFailure('Service Unavailable');
      case 504:
        return const NetworkFailure('Gateway Timeout');
      default:
        return ServerFailure('Error: $message');
    }
  }

  static Failure _mapAuthExceptionToFailure(AuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'user-disabled':
        return const UserDisabledFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'operation-not-allowed':
        return const OperationNotAllowedFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'requires-recent-login':
        return const RequiresRecentLoginFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'account-exists-with-different-credential':
        return const AccountExistsWithDifferentCredentialFailure();
      case 'invalid-credential':
        return const InvalidCredentialFailure();
      case 'invalid-verification-code':
        return const InvalidVerificationCodeFailure();
      case 'invalid-verification-id':
        return const InvalidVerificationIdFailure();
      default:
        return ServerFailure(exception.message);
    }
  }
}

class FormatFailure extends Failure {
  const FormatFailure([String message = 'Format error']) : super(message);
}
