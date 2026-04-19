import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/category/data/mappers/category_mapper.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/item/data/models/transferbank_model.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';
import 'package:intl/intl.dart';

class ItemModel {
    final int? id;
    final String? description;
    final bool? expense;
    final double? value;
    final DateTime? date;
    final CategoryModel? category;
    final CardModel? card;
    final TransferBankModel? transferBank;

    ItemModel({
      this.card,
      this.category,
      this.date,
      this.description,
      this.expense,
      this.id,
      this.transferBank,
      this.value
    });

    factory ItemModel.fromJson(dynamic data){
      int? id = data['id'];

      String? description = data['description'];

      bool? expense = data['expense'];

      double? value = double.tryParse(data['value'].toString()) ?? 0.0;

      DateTime? date = data['date'] == null
          ? null
          : DateFormat('yyyy-MM-dd').parse(data['date']['date']!);

      CategoryModel? category = data['category'] == null
          ? null
          : CategoryModel.fromJson(data['category']);

      CardModel? card =
          data['card'] == null ? null : CardModel.fromJson(data['card']!);

      TransferBankModel? transferBank = data['transfer_bank'] == null
          ? null
          : TransferBankModel.fromJson(data['transfer_bank']);

      return ItemModel(
          card: card,
          transferBank: transferBank,
          date: date,
          category: category,
          id: id,
          description: description,
          expense: expense,
          value: value);
    }

    Item toEntity() {
      return Item(
          id: id,
          description: description,
          expense: expense,
          value: value,
          date: date,
          category: CategoryMapper.toEntity(category!),
          card: card,
          transferBank: transferBank as TransferBank);
    }
}
