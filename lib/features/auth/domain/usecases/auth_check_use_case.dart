import 'package:drahkma/core/domain/entities/use_cases.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

class AuthCheckUseCase implements UseCases<User?>
{
  final AuthRepository _repository;
  AuthCheckUseCase(AuthRepository repository) : _repository = repository;

  @override
  Future<User?> call() async {
    return await _repository.checkSession();
  }
}