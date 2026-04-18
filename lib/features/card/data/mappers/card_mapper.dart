import 'package:drahkma/features/card/data/models/card_dto.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';

class CardMapper {
  /// Convert CardModel to Card entity
  static Card toEntity(CardModel model) {
    return Card(
      id: model.id,
      type: model.type,
      brand: model.brand,
      flag: model.flag,
      expiresAt: model.expiresAt,
      last4Digits: model.last4Digits,
      invoiceDay: model.invoiceDay,
    );
  }

  /// Convert Card entity to CardModel
  static CardModel toModel(Card entity) {
    return CardModel(
      id: entity.id,
      type: entity.type,
      brand: entity.brand,
      flag: entity.flag,
      expiresAt: entity.expiresAt,
      last4Digits: entity.last4Digits,
      invoiceDay: entity.invoiceDay,
    );
  }

  static CardDTO fromEntityToDTO(Card entity)
  {
    return CardDTO(
      id: entity.id,
      type: entity.type,
      brand: entity.brand,
      flag: entity.flag,
      expiresAt: entity.expiresAt,
      last4Digits: entity.last4Digits,
      invoiceDay: entity.invoiceDay,
    );
  }
}
