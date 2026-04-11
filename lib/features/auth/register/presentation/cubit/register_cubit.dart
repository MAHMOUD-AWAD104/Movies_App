import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/register/domain/usecases/register_usecase.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserEntity user;
  const RegisterSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String phone,
    String? avatarPath,
  }) async {
    emit(RegisterLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(username);
        await credential.user!.reload();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(credential.user!.uid)
            .set({
          'uId': credential.user!.uid,
          'username': username,
          'email': email,
          'phone': phone,
          'avatar': avatarPath ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        final userEntity = UserEntity(
          id: credential.user!.uid.hashCode,
          email: email,
          username: username,
          apiKey: '',
        );

        emit(RegisterSuccess(user: userEntity));
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = "حدث خطأ أثناء التسجيل";
      if (e.code == 'email-already-in-white') {
        errorMsg = "هذا البريد الإلكتروني مسجل بالفعل";
      } else if (e.code == 'weak-password') {
        errorMsg = "كلمة المرور ضعيفة جداً";
      }
      emit(RegisterFailure(message: errorMsg));
    } catch (e) {
      emit(RegisterFailure(message: e.toString()));
    }
  }
}
