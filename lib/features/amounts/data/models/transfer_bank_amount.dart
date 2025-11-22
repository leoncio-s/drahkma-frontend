
import 'package:drahkma/features/items/domain/enums/transfer_bank_type_enum.dart';

class TransferBankAmount{
  double? total = 0.0;
  String? description = "";
  TransferBankTypeEnum? type = TransferBankTypeEnum.OTHERS;

  TransferBankAmount({this.total, this.description, this.type});

  factory TransferBankAmount.fromJson(Map<String, dynamic> data){

    
    return TransferBankAmount(
      total: data['total'],
      description: data['description'],
      type: TransferBankTypeEnum.values.where((el) => el.name == data['type']).first
    );
  }

  @override
  String toString() {
    return {
      'total' : total,
      'description' : description,
      'type' : type!.name
    }.toString();
  }
}