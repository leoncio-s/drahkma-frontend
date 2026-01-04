import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User?> call({required Auth auth}) async {
    return await repository.login(
      auth: auth
    );
  } 
}