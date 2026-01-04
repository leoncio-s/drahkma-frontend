import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repo;
  LogoutUseCase({required AuthRepository repository}) : this._repo = repository;

  Future<void> call() async{
    await this._repo.logout();
  }
}