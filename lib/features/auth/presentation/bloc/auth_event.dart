part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChanged extends AuthEvent {
  final UserEntity user;

  const AuthStateChanged(this.user);

  @override
  List<Object> get props => [user];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const SignInRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object> get props => [email, password, displayName];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object> get props => [email, password, displayName];
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class SendPasswordResetEmail extends AuthEvent {
  final String email;

  const SendPasswordResetEmail(this.email);

  @override
  List<Object> get props => [email];
}

class UpdateProfile extends AuthEvent {
  final String? displayName;
  final String? photoURL;

  const UpdateProfile({this.displayName, this.photoURL});

  @override
  List<Object> get props => [
        if (displayName != null) displayName!,
        if (photoURL != null) photoURL!,
      ];
}

class DeleteAccount extends AuthEvent {}
