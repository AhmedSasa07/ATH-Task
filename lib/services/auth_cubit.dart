import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'An error occurred'));
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'An error occurred'));
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure('An error occurred while signing out'));
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}
class AuthLoggedOut extends AuthState {}