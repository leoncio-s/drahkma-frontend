import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/item/data/models/transferbank_model.dart';
import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';

class TransferBankMapper {
  /// Convert TransferBankModel to TransferBank entity
  static TransferBank toEntity(TransferBankModel model) {
    return TransferBank(
      id: model.id,
      type: model.type,
      description: model.description,
      bankAccount: model.bankAccount != null ? BankAccountMapper.toEntity(model.bankAccount!) : null,
    );
  }

  /// Convert TransferBank entity to TransferBankModel
  static TransferBankModel toModel(TransferBank entity) {
    return TransferBankModel(
      id: entity.id,
      type: entity.type,
      description: entity.description,
      bankAccount: entity.bankAccount != null ? BankAccountMapper.toModel(entity.bankAccount!) : null,
    );
  }
}
