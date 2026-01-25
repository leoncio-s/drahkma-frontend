
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/category/data/models/Category_model.dart';
import 'package:drahkma/features/item/data/models/transferbank_model.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';
import 'package:intl/intl.dart';

class ItemModel extends Item{
    ItemModel({
      super.card, super.category, super.date, super.description, super.expense, super.id, super.transferBank, super.value
    });

    factory ItemModel.fromJson(dynamic data){
      int? id = data['id'];
      
      String? description = data['description'];
      
      bool? expense = data['expense'];
      
      double? value = data['value'] ?? 0.0;
      
      DateTime? date = data['date'] == null ? null : DateFormat('yyyy-MM-dd').parse(data['date']['date']!);
      
      CategoryModel? category = data['category'] == null ? null : CategoryModel.fromJson(data['category']);
      
      CardModel? card = data['card'] == null? null : CardModel.fromJson(data['card']!);
      
      TransferBankModel? transferBank = data['transfer_bank'] == null ? null : TransferBankModel.fromJson(data['transfer_bank']);

      return ItemModel(
        card: card,
        transferBank: transferBank,
        date: date,
        category: category,
        id: id,
        description: description,
        expense: expense,
        value: value
        );
    }
    

      Item toEntity(){
        return Item(
          id: id,
          description: description,
          expense: expense,
          value: value,
          date: date,
          category: category,
          card: card,
          transferBank: transferBank as TransferBank
        );
      }
}