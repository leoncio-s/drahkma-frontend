import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank_accounts_dto.dart';
import 'package:drahkma/features/bank_accounts/domain/repositories/bank_accounts_repository.dart';

class BankAccountsUpdate implements UseCases
{
  final BankAccountsRepository _accountsRepository;
  BankAccountsUpdate(BankAccountsRepository repository) : _accountsRepository=repository;

  @override
  Future<void> call({BankAccountsDto? dto}) async{
    await _accountsRepository.delete(dto!);
    return;
  }
  
}