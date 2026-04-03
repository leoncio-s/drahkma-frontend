import 'package:drahkma/core/mixins/dto_mixin.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:intl/intl.dart';

class CardDTO extends Card with DTOMixin
{
    CardDTO({super.id, super.brand, super.expiresAt, super.flag, super.invoiceDay, super.last4Digits, super.type});

    @override
    Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'type' : type,
      'brand' : brand,
      'expires_at' : DateFormat('MMyy').format(expiresAt!),
      'flag' : flag!.name,
      'invoice_day' : invoiceDay,
      'last_4_digits' : last4Digits
    };
  }
}