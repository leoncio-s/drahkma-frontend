import 'package:drahkma/features/item/data/models/transfer_bank_dto.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:intl/intl.dart';

class ItemDTO extends Item
{
  ItemDTO({super.id, super.card, super.category, super.date, super.description, super.expense, super.transferBank, super.value});

  Map<String, dynamic> toMap() {
      return {
        'id' : id,
        'description' : description,
        'date' : DateFormat('yyyyMMdd').format(date!),
        'category': category!.id,
        'expense' : expense,
        'value' : value,
        'transfer_bank' : transferBank != null ? (transferBank as TransferBankDTO?)!.toMap() : transferBank,
        'card' : card != null ? card?.id : card
      };
    }
}