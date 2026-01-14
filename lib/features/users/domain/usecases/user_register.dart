import 'package:drahkma/Interfaces/use_cases.dart';
import 'package:drahkma/features/users/data/models/user_dto.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:drahkma/features/users/domain/repositories/user_repository.dart';

class UserRegister implements UseCases<UserModel>
{
  final UserRepository _repo;
  const UserRegister(UserRepository repository) : _repo = repository;

  @override
  call({UserDto? user}) async {
      UserModel? save = await _repo.save(user!) as UserModel;
      return save;

  }
  
}