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
    TransferBankDto? transfer_bank;

    ItemDto({
      this.card, this.category, this.date, this.description, this.expense, this.id, this.transfer_bank, this.value
    });

    factory ItemDto.toObject(dynamic data){


      int? _id = data['id'];
      String? _description = data['description'];
      bool? _expense = data['expense'];
      double? _value = data['value'] ?? 0.0;
      DateTime? _date = data['date'] == null ? null : DateFormat('yyyy-MM-dd').parse(data['date']['date']!);
      // DateTime? _date = data['date']['date'];
      CategoriesDto? _category = data['category'] == null ? null : CategoriesDto.toObject(data['category']);
      CardsDto? _card = data['card'] == null? null : CardsDto.toObject(data['card']!);
      TransferBankDto? _transfer_bank = data['transfer_bank'] == null ? null : TransferBankDto.toObject(data['transfer_bank']);

      return ItemDto(
        card: _card,
        transfer_bank: _transfer_bank,
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
          'transfer_bank' : transfer_bank != null ? transfer_bank!.toMap() : transfer_bank,
          'card' : card != null ? card?.id : card
        };
      }
}