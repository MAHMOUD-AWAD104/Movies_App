import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/forget_password/domain/usecases/forget_password_usecase.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;
  const ForgetPasswordSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String message;
  const ForgetPasswordFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase forgetPasswordUseCase;

  ForgetPasswordCubit({required this.forgetPasswordUseCase})
      : super(ForgetPasswordInitial());

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      emit(const ForgetPasswordSuccess(
          message: "A password reset link has been sent to your email."));
    } on FirebaseAuthException catch (e) {
      String errorMsg = "An error occurred, please try again.";
      if (e.code == 'user-not-found') {
        errorMsg = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "The email address is not valid.";
      }

      emit(ForgetPasswordFailure(message: errorMsg));
    } catch (e) {
      emit(ForgetPasswordFailure(message: e.toString()));
    }
  }
}
