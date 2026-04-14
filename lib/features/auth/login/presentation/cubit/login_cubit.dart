import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/login/domain/usecases/login_usecase.dart';

import '../../../../../core/services/firebase_service.dart';

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

  const LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await loginUseCase(
      LoginParams(
        email: email.trim(),
        password: password.trim(),
      ),
    );

    result.fold(
          (failure) => emit(LoginFailure(message: failure.message)),
          (user) => emit(LoginSuccess(user: user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    try {
      final user = await FirebaseService.loginWithGoogle();

      if (user == null) {
        emit(const LoginFailure(message: 'Google login cancelled'));
        return;
      }

      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }}