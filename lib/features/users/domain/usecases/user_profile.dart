import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:drahkma/features/users/domain/repositories/user_repository.dart';

class UserProfile implements UseCases<UserModel?>
{
  final UserRepository _repo;
  UserProfile(UserRepository repository) : _repo = repository;

  @override
  call() async {
    UserModel? profile = await _repo.profile() as UserModel;
    return profile;
  }
}