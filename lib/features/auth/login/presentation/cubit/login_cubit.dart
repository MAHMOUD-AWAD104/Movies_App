import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  const LoginSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String message;
  final String? code;
  const LoginFailure({required this.message, this.code});
  @override
  List<Object?> get props => [message, code];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      // Firebase Login
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userEntity = UserEntity(
          id: credential.user!.uid.hashCode,
          email: credential.user!.email ?? email,
          username: credential.user!.displayName ?? 'movieLover',
          apiKey: 'your_api_key_here',
        );
        emit(LoginSuccess(user: userEntity));
      } else {
        emit(const LoginFailure(
            message: "Failed to get user data from Firebase"));
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = "An authentication error occurred.";
      if (e.code == 'user-not-found') {
        errorMsg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "The email address is invalid.";
      } else if (e.code == 'user-disabled') {
        errorMsg = "This user has been disabled.";
      }

      emit(LoginFailure(message: errorMsg, code: e.code));
    } catch (e) {
      emit(LoginFailure(
          message: "An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(const LoginFailure(message: 'Google sign in cancelled'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user!;

      emit(
        LoginSuccess(
          user: UserEntity(
            id: user.uid.hashCode,
            email: user.email ?? '',
            username: user.displayName ?? 'movieLover',
            apiKey: 'google_auth_user',
          ),
        ),
      );
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}
