import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Check if user is signed in
  Stream<UserEntity> get authStateChanges;
  
  // Get current user
  UserEntity? get currentUser;
  
  // Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  // Sign up with email and password
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });
  
  // Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  
  // Sign out
  Future<Either<Failure, Unit>> signOut();
  
  // Send password reset email
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);
  
  // Update user profile
  Future<Either<Failure, Unit>> updateProfile({
    String? displayName,
    String? photoURL,
  });
  
  // Delete account
  Future<Either<Failure, Unit>> deleteAccount();
}
