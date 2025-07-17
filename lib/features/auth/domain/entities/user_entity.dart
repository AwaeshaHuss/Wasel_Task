import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isAnonymous;
  final bool isEmailVerified;

  const UserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.photoURL,
    this.isAnonymous = false,
    this.isEmailVerified = false,
  });

  static const empty = UserEntity(id: '');

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoURL,
        isAnonymous,
        isEmailVerified,
      ];
}
