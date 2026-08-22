import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/user/data/mappers/user_mapper.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:drahkma/features/user/domain/repositories/user_repository.dart';

class UserRegister implements UseCases<UserModel>
{
  final UserRepository _repo;
  const UserRegister(UserRepository repository) : _repo = repository;

  @override
  Future<UserModel?> call({UserDTO? user}) async {
      User? saved = await _repo.save(user!);
      return UserMapper.toModel(saved!);
  }
  
}