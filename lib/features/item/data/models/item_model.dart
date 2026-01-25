
import 'package:drahkma/features/cards/data/models/card_model.dart';
import 'package:drahkma/features/categories/data/models/category_model.dart';
import 'package:drahkma/features/items/data/models/transferbank_model.dart';
import 'package:drahkma/features/items/domain/entities/item.dart';
import 'package:intl/intl.dart';

class ItemModel{

    int? id;
    String? description;
    bool? expense;
    double? value;
    DateTime? date;
    CategoryModel? category;
    CardModel? card;
    TransferBankModel? transferBank;

    ItemModel({
      this.card, this.category, this.date, this.description, this.expense, this.id, this.transferBank, this.value
    });

    factory ItemModel.toObject(dynamic data){
      int? id = data['id'];
      
      String? description = data['description'];
      
      bool? expense = data['expense'];
      
      double? value = data['value'] ?? 0.0;
      
      DateTime? date = data['date'] == null ? null : DateFormat('yyyy-MM-dd').parse(data['date']['date']!);
      
      CategoryModel? category = data['category'] == null ? null : CategoryModel.toObject(data['category']);
      
      CardModel? card = data['card'] == null? null : CardModel.toObject(data['card']!);
      
      TransferBankModel? transferBank = data['transfer_bank'] == null ? null : TransferBankModel.toObject(data['transfer_bank']);

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
    
      
      Map<String, dynamic> toMap() {
        return {
          'id' : id,
          'description' : description,
          'date' : DateFormat('yyyyMMdd').format(date!),
          'category': category!.id,
          'expense' : expense,
          'value' : value,
          'transfer_bank' : transferBank != null ? transferBank!.toMap() : transferBank,
          'card' : card != null ? card?.id : card
        };
      }

      Item toEntity(){
        return Item(
          id: id,
          description: description,
          expense: expense,
          value: value,
          date: date,
          category: category,
          card: card?.toEntity(),
          transferBank: transferBank
        );
      }
}