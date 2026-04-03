import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/bank_account/data/models/bank_model.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';

class BankAccountBank implements UseCases<List<BankModel>?>
{
  final BankAccountRepository _accountsRepository;
  BankAccountBank(BankAccountRepository repository) : _accountsRepository=repository;
  @override
  Future<List<BankModel>?> call() async {
    List? data = await _accountsRepository.getBanks();
    data as List<BankModel>;
    return data;
  }

}