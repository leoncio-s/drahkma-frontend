import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

class LoginUseCase implements UseCases<User>{
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<User?> call({Auth? auth}) async {
    return await repository.login(
      auth: auth!
    );
  } 
}