import 'package:flutter/material.dart';
import 'package:drahkma/features/cards/domain/enums/cards_flags_enum.dart';
import 'package:drahkma/features/cards/domain/enums/cards_type_enum.dart';
import 'package:intl/intl.dart';

class Card{
    int? _id;
    CardsTypeEnum? _type;
    String? _brand;
    CardFlagsEnum? _flag;
    DateTime? _expiresAt;
    String? _last4Digits;
    int? _invoiceDay;


    Card({
      int? id, 
      CardsTypeEnum? type,
      String? brand,
      String? expiresAt,
      CardFlagsEnum? flag,
      int? invoiceDay,
      String? last4Digits
    }){
      setId = id;
      setBrand = brand;
      setExpiresAt = expiresAt.toString();
      setFlag = flag;
      setInvoice_day = invoiceDay;
      setLast_4_digits = last4Digits;
      setType = type;
    }

    set setId(int? id) => _id = id;
    set setType(CardsTypeEnum? type) => _type = type;
    set setBrand(String? brand) => _brand = brand;
    set setFlag(CardFlagsEnum? flag) => _flag = flag;
  
    set setExpiresAt(String? exp){

      try{
        DateTime dt = DateFormat('MM/yyyy').parse(exp!);
        _expiresAt = dt;
      }catch(e){
        _expiresAt = null;
      }
      
    }
    // ignore: non_constant_identifier_names
    set setLast_4_digits(String? lst) => _last4Digits = lst;
    // ignore: non_constant_identifier_names
    set setInvoice_day(int? invoice){
      // var val = DateTime.parse(invoice!);
      if((invoice! > 0 && invoice < 31)){
        _invoiceDay = invoice;
      }else{
        _invoiceDay = null;
      }
    }


    String? get brand => _brand;
    int? get id => _id;
    CardsTypeEnum? get type => _type;
    DateTime? get expiresAt => _expiresAt;
    CardFlagsEnum? get flag => _flag;

    String? get last4Digits => _last4Digits;
    int? get invoiceDay => _invoiceDay;


    DateTime get nextInvoiceDate{
      DateTime date = DateTime(DateTime.now().year, DateTime.now().month, int.parse(_invoiceDay.toString()));
      DateTime now = DateTime.now();
      if(date.isBefore(now)){
        date = DateUtils.addMonthsToMonthDate(date, 1);
      }
      if(date.weekday == DateTime.sunday){
        date.add(const Duration(days: 1));
      }else if(date.weekday == DateTime.saturday){
        date.add(const Duration(days: 2));
      }
      return date;
    }

  @override
  factory Card.toObject(Map<String, dynamic> data) {
    String? dataBrand = data['brand'] ?? "";
    int? dataId = data['id'] ?? 0;
    // setUser = data['user'] ?? 0;
    CardsTypeEnum? dataType = CardsTypeEnum.values.firstWhere((val) => val.name == data['type'].toString());
    CardFlagsEnum? dataFlag = CardFlagsEnum.values.firstWhere((val) => val.name == data['flag'].toString());
    String? dataExpiresAt = data['expires_at'] ?? "";
    int? dataInvoiceDay = data['invoice_day'] ?? 1;
    String? dataLast4Digits = data['last_4_digits'] ?? "";

    return Card(
      id: dataId, 
      brand: dataBrand,
      type: dataType,
      flag: dataFlag,
      expiresAt: dataExpiresAt,
      invoiceDay: dataInvoiceDay,
      last4Digits: dataLast4Digits
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id' : _id,
      'type' : _type!.name,
      'brand' : _brand,
      'expires_at' : DateFormat('MMyy').format(_expiresAt!),
      'flag' : _flag!.name,
      'invoice_day' : _invoiceDay,
      'last_4_digits' : _last4Digits
    };
  }
  
}

class CardsSort{
  static Comparator<Card> asc = (Card it1, Card it2) =>  it1.brand!.compareTo(it2.brand.toString());

  static Comparator<Card> desc = (Card it1, Card it2) => it2.brand!.compareTo(it1.brand.toString());
}