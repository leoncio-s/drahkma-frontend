import 'package:drahkma/core/domain/entities/use_cases.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';

class AuthGetSavedEmailUseCase implements UseCases<String?>
{
  final AuthRepository _repository;
  AuthGetSavedEmailUseCase(AuthRepository repository) : _repository = repository;

  @override
  Future<String?> call() async {
    return _repository.getLocalSavedEmail();
  }
}