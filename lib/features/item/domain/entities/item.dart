import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/category/domain/entities/Category.dart';
import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';

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