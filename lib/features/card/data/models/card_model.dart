import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/enums/card_flag_enum.dart';
import 'package:drahkma/features/card/domain/enums/card_type_enum.dart';

class CardModel extends Card{
    CardModel({ 
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
  factory CardModel.fromJson(Map<String, dynamic> data) {
    String? dataBrand = data['brand'] ?? "";
    int? dataId = data['id'] ?? 0;
    CardTypeEnum? dataType = CardTypeEnum.values.firstWhere((val) => val.name == data['type'].toString());
    CardFlagEnum? dataFlag = CardFlagEnum.values.firstWhere((val) => val.name == data['flag'].toString());
    String? dataExpiresAt = data['expires_at'] ?? "";
    int? dataInvoiceDay = data['invoice_day'] ?? 1;
    String? dataLast4Digits = data['last_4_digits'] ?? "";

    return CardModel(
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