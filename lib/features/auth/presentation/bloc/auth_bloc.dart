import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/auth/domain/entities/user_entity.dart';
import 'package:wasel_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStateChanged>(_onAuthStateChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteAccount>(_onDeleteAccount);
    
    // Subscribe to auth state changes
    _authRepository.authStateChanges.listen((user) {
      add(AuthStateChanged(user));
    });
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user.isNotEmpty) {
      emit(Authenticated(event.user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.sendPasswordResetEmail(event.email);

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(PasswordResetEmailSent()),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.updateProfile(
      displayName: event.displayName,
      photoURL: event.photoURL,
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) {
        final updatedUser = _authRepository.currentUser;
        if (updatedUser != null) {
          emit(ProfileUpdated(updatedUser));
        } else {
          emit(const AuthError('User not found'));
        }
      },
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.deleteAccount();

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(AccountDeleted()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case InvalidEmailFailure:
        return 'Invalid email address';
      case UserDisabledFailure:
        return 'This account has been disabled';
      case UserNotFoundFailure:
        return 'No user found with this email';
      case WrongPasswordFailure:
        return 'Incorrect password';
      case EmailAlreadyInUseFailure:
        return 'This email is already in use';
      case OperationNotAllowedFailure:
        return 'This operation is not allowed';
      case WeakPasswordFailure:
        return 'The password provided is too weak';
      case RequiresRecentLoginFailure:
        return 'Please sign in again to perform this operation';
      case TooManyRequestsFailure:
        return 'Too many requests. Please try again later';
      case AccountExistsWithDifferentCredentialFailure:
        return 'An account already exists with the same email but different sign-in credentials';
      case InvalidCredentialFailure:
        return 'The credential is invalid';
      case InvalidVerificationCodeFailure:
        return 'The verification code is invalid';
      case InvalidVerificationIdFailure:
        return 'The verification ID is invalid';
      case UnauthenticatedFailure:
        return 'User is not authenticated';
      case CanceledAuthFailure:
        return 'Authentication was canceled';
      default:
        return 'An unexpected error occurred';
    }
  }
}
