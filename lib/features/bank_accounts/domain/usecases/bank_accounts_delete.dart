import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_accounts/domain/repositories/bank_accounts_repository.dart';

class BankAccountsDelete implements UseCases
{
  final BankAccountsRepository _accountsRepository;
  BankAccountsDelete(BankAccountsRepository repository): _accountsRepository=repository;

  @override
  Future<void> call({BankAccount? dto}) async
  {
    await _accountsRepository.delete(dto!);
  }
}