import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';

class BankAccountUpdate implements UseCases
{
  final BankAccountRepository _accountsRepository;
  BankAccountUpdate(BankAccountRepository repository) : _accountsRepository=repository;

  @override
  Future<void> call({BankAccountDTO? dto}) async{
    await _accountsRepository.delete(dto!);
    return;
  }
  
}