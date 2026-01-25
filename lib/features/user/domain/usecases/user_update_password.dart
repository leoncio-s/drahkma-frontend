import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/user/domain/repositories/user_repository.dart';

class UserUpdatePassword implements UseCases
{
  final UserRepository _repo;
  UserUpdatePassword(UserRepository repository) : _repo=repository;
  
  @override
  Future<void> call({String? currentPassword, String? newPassword, String? confirmNewPassword }) async {
    await _repo.updatePassword(currentPassword: currentPassword!, newPassword: newPassword!, confirmNewPassword: confirmNewPassword!);
  }
}