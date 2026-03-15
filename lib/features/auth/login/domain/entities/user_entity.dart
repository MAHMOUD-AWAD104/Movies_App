import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String username;
  final String email;
  final String apiKey;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.apiKey,
  });

  @override
  List<Object?> get props => [id, email];
}
