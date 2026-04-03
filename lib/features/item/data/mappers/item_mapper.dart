import 'package:drahkma/features/card/data/mappers/card_mapper.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/category/data/mappers/category_mapper.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/item/data/mappers/transfer_bank_mapper.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/data/models/transferbank_model.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';

class ItemMapper {
  /// Convert ItemModel to Item entity
  static Item toEntity(ItemModel model) {
    return Item(
      id: model.id,
      description: model.description,
      expense: model.expense,
      value: model.value,
      date: model.date,
      category: model.category != null ? CategoryMapper.toEntity(model.category!) : null,
      card: model.card != null ? CardMapper.toEntity(model.card!) : null,
      transferBank: model.transferBank != null ? TransferBankMapper.toEntity(model.transferBank!) : null,
    );
  }

  /// Convert Item entity to ItemModel
  static ItemModel toModel(Item entity) {
    return ItemModel(
      id: entity.id,
      description: entity.description,
      expense: entity.expense,
      value: entity.value,
      date: entity.date,
      category: entity.category != null ? CategoryMapper.toModel(entity.category!) : null,
      card: entity.card != null ? CardMapper.toModel(entity.card!) : null,
      transferBank: entity.transferBank != null ? TransferBankMapper.toModel(entity.transferBank!) : null,
    );
  }
}
