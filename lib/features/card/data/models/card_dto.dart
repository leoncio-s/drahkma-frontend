import 'package:drahkma/core/mixins/dto_mixin.dart';
import 'package:drahkma/features/card/domain/enums/card_flag_enum.dart';
import 'package:drahkma/features/card/domain/enums/card_type_enum.dart';
import 'package:intl/intl.dart';

class CardDTO with DTOMixin {
    final int? id;
    final CardTypeEnum? type;
    final String? brand;
    final CardFlagEnum? flag;
    final DateTime? expiresAt;
    final String? last4Digits;
    final int? invoiceDay;

    CardDTO({
      this.id, 
      this.type,
      this.brand, 
      this.expiresAt, 
      this.flag, 
      this.invoiceDay, 
      this.last4Digits
    });

    @override
    Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'type' : type!.name,
      'brand' : brand,
      'expires_at' : DateFormat('MMyy').format(expiresAt!),
      'flag' : flag!.name,
      'invoice_day' : invoiceDay,
      'last_4_digits' : last4Digits
    };
  }
}