import 'package:drahkma/Cards/cards_dto.dart';
import 'package:drahkma/Categories/categories_dto.dart';
import 'package:drahkma/Interfaces/dto_interface.dart';
import 'package:drahkma/Tranferbank/transferbank_dto.dart';
import 'package:intl/intl.dart';

class ItemDto extends DtoInterface{

    int? id;
    String? description;
    bool? expense;
    double? value;
    DateTime? date;
    CategoriesDto? category;
    CardsDto? card;
    TransferBankDto? transferBank;

    ItemDto({
      this.card, this.category, this.date, this.description, this.expense, this.id, this.transferBank, this.value
    });

    factory ItemDto.toObject(dynamic data){


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
      CategoriesDto? _category = data['category'] == null ? null : CategoriesDto.toObject(data['category']);
      // ignore: no_leading_underscores_for_local_identifiers
      CardsDto? _card = data['card'] == null? null : CardsDto.toObject(data['card']!);
      // ignore: no_leading_underscores_for_local_identifiers
      TransferBankDto? _transferBank = data['transfer_bank'] == null ? null : TransferBankDto.toObject(data['transfer_bank']);

      return ItemDto(
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
    
      @override
      toMap() {
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