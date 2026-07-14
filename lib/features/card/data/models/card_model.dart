import 'package:drahkma/features/card/domain/enums/card_flag_enum.dart';
import 'package:drahkma/features/card/domain/enums/card_type_enum.dart';

class CardModel {
    final int? id;
    final CardTypeEnum? type;
    final String? brand;
    final CardFlagEnum? flag;
    final DateTime? expiresAt;
    final String? last4Digits;
    final int? invoiceDay;

    CardModel({ 
      this.id, 
      this.type,
      this.brand,
      this.expiresAt,
      this.flag,
      this.invoiceDay,
      this.last4Digits
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

  factory CardModel.fromJson(Map<String, dynamic> data) {
    String? dataBrand = data['brand'] ?? "";
    int? dataId = data['id'] ?? 0;
    CardTypeEnum? dataType = CardTypeEnum.values.firstWhere((val) => val.name.toLowerCase() == data['type'].toString().toLowerCase(), orElse: ()=>CardTypeEnum.Others);
    CardFlagEnum? dataFlag = CardFlagEnum.values.firstWhere((val) => val.name.toLowerCase() == data['flag'].toString().toLowerCase(), orElse: ()=>CardFlagEnum.Others);
    int? dataInvoiceDay = data['invoice_day'] ?? 1;
    String? dataLast4Digits = data['last_4_digits'] ?? "";

    DateTime? dataExpiresAtDateTime;
    if(data['expires_at'] != null)
    {
      var dataExpiresAt = data['expires_at'].toString().split('/');
      dataExpiresAtDateTime = DateTime(int.parse(dataExpiresAt[1]), int.parse(dataExpiresAt[0]));
    }

    return CardModel(
      id: dataId, 
      brand: dataBrand,
      type: dataType,
      flag: dataFlag,
      expiresAt: dataExpiresAtDateTime,
      invoiceDay: dataInvoiceDay,
      last4Digits: dataLast4Digits
    );
  }

}