import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';
import 'package:drahkma/features/item/data/models/transfer_bank_dto.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';
import 'package:intl/intl.dart';

class ItemDTO {
  final int? id;
  final String? description;
  final bool? expense;
  final double? value;
  final DateTime? date;
  final Category? category;
  final Card? card;
  final TransferBank? transferBank;

  ItemDTO({
    this.id, 
    this.card, 
    this.category, 
    this.date, 
    this.description, 
    this.expense, 
    this.transferBank, 
    this.value
  });

  factory ItemDTO.fromModel(Item item) {
    return ItemDTO(
      id: item.id,
      description: item.description,
      expense: item.expense,
      value: item.value,
      date: item.date,
      category: item.category,
      card: item.card,
      transferBank: item.transferBank,
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
        'transfer_bank' : transferBank != null ? TransferBankDTO.fromModel(transferBank!).toMap() : transferBank,
        'card' : card != null ? card?.id : card
      };
    }
}