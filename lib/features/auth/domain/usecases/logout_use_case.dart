import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCases{
  final AuthRepository _repo;
  LogoutUseCase({required AuthRepository repository}) : _repo = repository;

  @override
  Future<void> call() async{
    await _repo.logout();
  }
}