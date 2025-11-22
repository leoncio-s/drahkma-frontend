
import 'package:drahkma/features/cards/data/models/card.dart';
import 'package:drahkma/features/categories/data/models/category.dart';
import 'package:drahkma/features/items/data/models/transferbank.dart';
import 'package:intl/intl.dart';

class Item{

    int? id;
    String? description;
    bool? expense;
    double? value;
    DateTime? date;
    Category? category;
    Card? card;
    TransferBank? transferBank;

    Item({
      this.card, this.category, this.date, this.description, this.expense, this.id, this.transferBank, this.value
    });

    factory Item.toObject(dynamic data){


      // ignore: no_leading_underscores_for_local_identifiers
      int? _id = data['id'];
      // ignore: no_leading_underscores_for_local_identifiers
      String? _description = data['description'];
      // ignore: no_leading_underscores_for_local_identifiers
      bool? _expense = data['expense'];
      // ignore: no_leading_underscores_for_local_identifiers
      double? _value = data['value'] ?? 0.0;
      // ignore: no_leading_underscores_for_local_identifiers
      DateTime? _date = data['date'] == null ? null : DateFormat('yyyy-MM-dd').parse(data['date']['date']!);
      // ignore: no_leading_underscores_for_local_identifiers
      Category? _category = data['category'] == null ? null : Category.toObject(data['category']);
      // ignore: no_leading_underscores_for_local_identifiers
      Card? _card = data['card'] == null? null : Card.toObject(data['card']!);
      // ignore: no_leading_underscores_for_local_identifiers
      TransferBank? _transferBank = data['transfer_bank'] == null ? null : TransferBank.toObject(data['transfer_bank']);

      return Item(
        card: _card,
        transferBank: _transferBank,
        date: _date,
        category: _category,
        id: _id,
        description: _description,
        expense: _expense,
        value: _value
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
}