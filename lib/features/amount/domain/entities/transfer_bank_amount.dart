
import 'package:drahkma/features/item/domain/enums/transfer_bank_type_enum.dart';

class TransferBankAmount {
  double? total = 0.0;
  String? description = "";
  TransferBankTypeEnum? type = TransferBankTypeEnum.OTHERS;

  TransferBankAmount({this.total, this.description, this.type});
}