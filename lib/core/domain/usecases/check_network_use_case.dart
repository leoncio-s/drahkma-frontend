import 'package:drahkma/core/domain/repositories/app_repository.dart';
import 'package:drahkma/core/domain/usecases/use_cases.dart';

class CheckNetworkUseCase implements UseCases
{
  final AppRepository _repository;
  const CheckNetworkUseCase(this._repository);
  @override
  Future<bool?> call() async {
    var res = await _repository.ckeckNetworkConnection();
    return res;
  }
  
}