import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';

class BankAccountSave implements UseCases<BankAccount>{
  
  final BankAccountRepository _accountsRepository;
  BankAccountSave(BankAccountRepository repository) : _accountsRepository = repository;
  @override
  Future<BankAccount?> call({BankAccountDTO? dto}) async {
    BankAccount? data = await _accountsRepository.save(BankAccountMapper.fromDTOToEntity(dto!));
    return data;
  }

}