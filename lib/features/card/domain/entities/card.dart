import 'package:drahkma/features/card/domain/enums/card_flag_enum.dart';
import 'package:drahkma/features/card/domain/enums/card_type_enum.dart';

class Card{
    final int? id;
    final CardTypeEnum? type;
    final String? brand;
    final CardFlagEnum? flag;
    final DateTime? expiresAt;
    final String? last4Digits;
    final int? invoiceDay;


    Card({
      this.id, 
      this.type,
      this.brand,
      this.expiresAt,
      this.flag,
      this.invoiceDay,
      this.last4Digits
    });
}