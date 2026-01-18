import 'package:drahkma/features/cards/domain/enums/cards_flags_enum.dart';
import 'package:drahkma/features/cards/domain/enums/cards_type_enum.dart';

class Cards{
    final int? id;
    final CardsTypeEnum? type;
    final String? brand;
    final CardFlagsEnum? flag;
    final DateTime? expiresAt;
    final String? last4Digits;
    final int? invoiceDay;


    Cards({
      this.id, 
      this.type,
      this.brand,
      this.expiresAt,
      this.flag,
      this.invoiceDay,
      this.last4Digits
    });
}