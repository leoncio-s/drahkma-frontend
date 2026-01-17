import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank_accounts_dto.dart';
import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_accounts/domain/repositories/bank_accounts_repository.dart';

class BankAccountsSave implements UseCases<BankAccount>{
  
  final BankAccountsRepository _accountsRepository;
  BankAccountsSave(BankAccountsRepository repository) : _accountsRepository = repository;
  @override
  Future<BankAccount?> call({BankAccountsDto? dto}) async {
    BankAccount? data = await _accountsRepository.save(dto!);
    return data;
  }

}