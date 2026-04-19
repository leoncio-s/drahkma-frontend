import 'package:drahkma/features/amount/domain/entities/transfer_bank_amount.dart';
import 'package:drahkma/features/item/domain/enums/transfer_bank_type_enum.dart';

class TransferBankAmountModel extends TransferBankAmount {
  TransferBankAmountModel({super.total, super.description, super.type});

  factory TransferBankAmountModel.fromJson(Map<String, dynamic> data) {
    return TransferBankAmountModel(
        total: double.tryParse(data['total'].toString()) ?? 0.00,
        description: data['description'],
        type: TransferBankTypeEnum.values
            .where((el) => el.name == data['type'])
            .first);
  }

  @override
  String toString() {
    return {'total': total, 'description': description, 'type': type!.name}
        .toString();
  }

  Map<String, dynamic> toMap() {
    return {'total': total, 'description': description, 'type': type!.name};
  }
}
