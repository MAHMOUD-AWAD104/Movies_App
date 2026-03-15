import 'package:equatable/equatable.dart';
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
    final result = await forgetPasswordUseCase(email);
    result.fold(
      (failure) => emit(ForgetPasswordFailure(message: failure.message)),
      (message) => emit(ForgetPasswordSuccess(message: message)),
    );
  }
}
