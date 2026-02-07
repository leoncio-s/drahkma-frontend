import 'package:drahkma/core/domain/entities/use_cases.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

class AuthUseCase implements UseCases<User>{
  final AuthRepository _repository;
  AuthUseCase(AuthRepository repository) : _repository=repository;

  @override
  Future<User?> call({Auth? auth}) async {
    return await _repository.login(
      auth: auth!
    );
  } 
}