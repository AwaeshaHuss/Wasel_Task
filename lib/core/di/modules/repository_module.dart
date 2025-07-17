import 'package:firebase_auth/firebase_auth.dart';

abstract class RepositoryModule {
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  // CartRepository is automatically registered via @LazySingleton annotation
}
