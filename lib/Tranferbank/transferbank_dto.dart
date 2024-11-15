import 'package:front_lfinanca/BankAccounts/bank_accounts_dto.dart';
import 'package:front_lfinanca/Interfaces/dto_interface.dart';
import 'package:front_lfinanca/Tranferbank/transfer_bank_type_enum.dart';

class TransferBankDto extends DtoInterface {
    int? id;
    TransferBankTypeEnum? type;
    String? description;
    BankAccountsDto? bankAccount;

    TransferBankDto({this.bankAccount, this.description, this.id, this.type}){
      // type = type;
    }
    
      @override
      toMap() {
        return {
          'id' : id,
          'type' : type!.name,
          'description' : description,
          'bank_account' : bankAccount!.id
        };
      }
    
      @override
      factory TransferBankDto.toObject(Map<String, dynamic> data) {
        BankAccountsDto? bankAccountsDto = BankAccountsDto.toObject(data['bank_account']);
        TransferBankTypeEnum? _type = TransferBankTypeEnum.values.firstWhere((val) => val.name.contains(data['type']));
        return TransferBankDto(id: data['id'], description: data['description'], type: _type, bankAccount: bankAccountsDto);
      }
}