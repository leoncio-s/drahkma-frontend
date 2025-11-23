import 'package:drahkma/features/cards/domain/entities/card.dart';
import 'package:drahkma/features/categories/domain/entities/category.dart';
import 'package:drahkma/features/items/domain/entities/transfer_bank.dart';

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
}