import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';
import 'package:drahkma/features/users/domain/repositories/user_repository.dart';

class UserUpdate implements UseCases<void>
{
  final UserRepository _repo;

  UserUpdate(UserRepository repository) : _repo = repository;

  @override
  Future<void> call({User? user}) async {
    await _repo.update(user!);
  }
  
}