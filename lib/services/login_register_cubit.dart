import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';

class LoginRegisterCubit extends Cubit<LoginRegisterState> {
  final AuthCubit _authCubit;

  LoginRegisterCubit(this._authCubit) : super(LoginMode());

  void toggleMode() {
    if (state is LoginMode) {
      emit(RegisterMode());
    } else {
      emit(LoginMode());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(LoginRegisterLoading());
    try {
      await _authCubit.signInWithEmailAndPassword(email, password);
      emit(LoginRegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginRegisterFailure('No user found for this email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginRegisterFailure('Wrong password provided for this user.'));
      } else if (e.code == 'invalid-email') {
        emit(LoginRegisterFailure('Invalid email format.'));
      } else {
        emit(LoginRegisterFailure('An unexpected error occurred: ${e.message}'));
      }
    } catch (e) {
      emit(LoginRegisterFailure('An unknown error occurred.'));
    }
  }


  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    emit(LoginRegisterLoading());
    try {
      await _authCubit.createUserWithEmailAndPassword(email, password);
      emit(LoginRegisterSuccess());
    } on AuthFailure catch (e) {
      emit(LoginRegisterFailure(e.errorMessage));
    }
  }
}

abstract class LoginRegisterState {}

class LoginRegisterInitial extends LoginRegisterState {}
class LoginMode extends LoginRegisterState {}
class RegisterMode extends LoginRegisterState {}
class LoginRegisterSuccess extends LoginRegisterState {}
class LoginRegisterFailure extends LoginRegisterState {
  final String errorMessage;
  LoginRegisterFailure(this.errorMessage);

}
class LoginRegisterLoading extends LoginRegisterState {}