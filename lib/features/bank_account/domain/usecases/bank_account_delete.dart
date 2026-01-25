import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';

class BankAccountDelete implements UseCases
{
  final BankAccountRepository _accountsRepository;
  BankAccountDelete(BankAccountRepository repository): _accountsRepository=repository;

  @override
  Future<void> call({BankAccount? dto}) async
  {
    await _accountsRepository.delete(dto!);
  }
}