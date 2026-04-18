import 'package:drahkma/features/card/data/mappers/card_mapper.dart';
import 'package:drahkma/features/category/data/mappers/category_mapper.dart';
import 'package:drahkma/features/item/data/mappers/transfer_bank_mapper.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
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

  static ItemModel fromDTOToModel(ItemDTO dto)
  {
    return ItemModel(
      id: dto.id,
      description: dto.description,
      expense: dto.expense,
      value: dto.value,
      date: dto.date,
      category: dto.category != null ? CategoryMapper.toModel(dto.category!) : null,
      card: dto.card != null ? CardMapper.toModel(dto.card!) : null,
      transferBank: dto.transferBank != null ? TransferBankMapper.toModel(dto.transferBank!) : null,
    );
  }

  static Item fromDTOToEntity(ItemDTO dto)
  {
    return Item(
      id: dto.id,
      description: dto.description,
      expense: dto.expense,
      value: dto.value,
      date: dto.date,
      category: dto.category,
      card: dto.card,
      transferBank: dto.transferBank,
    );
  }
}
