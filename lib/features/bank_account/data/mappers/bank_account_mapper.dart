import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';

class BankAccountMapper {
  /// Convert BankAccountModel to BankAccount entity
  static BankAccount toEntity(BankAccountModel model) {
    return BankAccount(
      id: model.id,
      bankCode: model.bankCode,
      accountNumber: model.accountNumber,
      agency: model.agency,
      bankName: model.bankName,
    );
  }

  /// Convert BankAccount entity to BankAccountModel
  static BankAccountModel toModel(BankAccount entity) {
    return BankAccountModel(
      id: entity.id,
      bankCode: entity.bankCode,
      accountNumber: entity.accountNumber,
      agency: entity.agency,
      bankName: entity.bankName,
    );
  }

  /// converte entity para dto
  static BankAccountDTO fromEntityToDTO(BankAccount entity)
  {
    return BankAccountDTO(
      id: entity.id,
      bankCode: entity.bankCode,
      accountNumber: entity.accountNumber,
      agency: entity.agency,
      bankName: entity.bankName,
    );
  }

  static BankAccountDTO fromModelToDTO(BankAccountModel model)
  {
    return BankAccountDTO(
      id: model.id,
      bankCode: model.bankCode,
      accountNumber: model.accountNumber,
      agency: model.agency,
      bankName: model.bankName,
    );
  }

  static BankAccount fromDTOToEntity(BankAccountDTO dto)
  {
    return BankAccount(
      id: dto.id,
      bankCode: dto.bankCode,
      accountNumber: dto.accountNumber,
      agency: dto.agency,
      bankName: dto.bankName,
    ); 
  }
}
