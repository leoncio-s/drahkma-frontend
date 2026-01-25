import 'package:drahkma/features/cards/domain/entities/cards.dart';
import 'package:drahkma/features/cards/domain/enums/cards_flags_enum.dart';
import 'package:drahkma/features/cards/domain/enums/cards_type_enum.dart';

class CardsModel extends Cards{
    CardsModel({ 
      super.id, 
      super.type,
      super.brand,
      super.expiresAt,
      super.flag,
      super.invoiceDay,
      super.last4Digits
    });

    DateTime get nextInvoiceDate{
      DateTime date = DateTime(DateTime.now().year, DateTime.now().month, int.parse(invoiceDay.toString()));
      DateTime now = DateTime.now();
      if(date.isBefore(now)){
        date = DateTime(date.year, date.month + 1, date.day);
      }
      if(date.weekday == DateTime.sunday){
        date.add(const Duration(days: 1));
      }else if(date.weekday == DateTime.saturday){
        date.add(const Duration(days: 2));
      }
      return date;
    }

  @override
  factory CardsModel.fromJson(Map<String, dynamic> data) {
    String? dataBrand = data['brand'] ?? "";
    int? dataId = data['id'] ?? 0;
    CardsTypeEnum? dataType = CardsTypeEnum.values.firstWhere((val) => val.name == data['type'].toString());
    CardFlagsEnum? dataFlag = CardFlagsEnum.values.firstWhere((val) => val.name == data['flag'].toString());
    String? dataExpiresAt = data['expires_at'] ?? "";
    int? dataInvoiceDay = data['invoice_day'] ?? 1;
    String? dataLast4Digits = data['last_4_digits'] ?? "";

    return CardsModel(
      id: dataId, 
      brand: dataBrand,
      type: dataType,
      flag: dataFlag,
      expiresAt: DateTime.parse(dataExpiresAt!),
      invoiceDay: dataInvoiceDay,
      last4Digits: dataLast4Digits
    );
  }

}