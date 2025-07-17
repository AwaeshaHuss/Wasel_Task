import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:wasel_task/features/auth/domain/entities/user_entity.dart';
import 'package:wasel_task/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl(
    this._firebaseAuth,
    this._googleSignIn,
  );

  @override
  Stream<UserEntity> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? UserEntity.empty : firebaseUser.toEntity();
    });
  }

  @override
  UserEntity? get currentUser {
    return _firebaseAuth.currentUser?.toEntity();
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user!.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();
      
      return Right(userCredential.user!.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left(CanceledAuthFailure());
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return Right(userCredential.user!.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthenticatedFailure());
      }

      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      await user.reload();
      
      return const Right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthenticatedFailure());
      }

      await user.delete();
      return const Right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Failure _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return InvalidEmailFailure();
      case 'user-disabled':
        return UserDisabledFailure();
      case 'user-not-found':
        return UserNotFoundFailure();
      case 'wrong-password':
        return WrongPasswordFailure();
      case 'email-already-in-use':
        return EmailAlreadyInUseFailure();
      case 'operation-not-allowed':
        return OperationNotAllowedFailure();
      case 'weak-password':
        return WeakPasswordFailure();
      case 'requires-recent-login':
        return RequiresRecentLoginFailure();
      case 'too-many-requests':
        return TooManyRequestsFailure();
      case 'account-exists-with-different-credential':
        return AccountExistsWithDifferentCredentialFailure();
      case 'invalid-credential':
        return InvalidCredentialFailure();
      case 'invalid-verification-code':
        return InvalidVerificationCodeFailure();
      case 'invalid-verification-id':
        return InvalidVerificationIdFailure();
      default:
        return ServerFailure(e.message ?? 'Something went wrong');
    }
  }
}

extension on firebase_auth.User {
  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      isAnonymous: isAnonymous,
      isEmailVerified: emailVerified,
    );
  }
}
