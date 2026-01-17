import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank_model.dart';
import 'package:drahkma/features/bank_accounts/domain/repositories/bank_accounts_repository.dart';

class BankAccountsBanks implements UseCases<List<BankModel>?>
{
  final BankAccountsRepository _accountsRepository;
  BankAccountsBanks(BankAccountsRepository repository) : _accountsRepository=repository;
  @override
  Future<List<BankModel>?> call() async {
    List? data = await _accountsRepository.getBanks();
    data as List<BankModel>;
    return data;
  }

}