import 'package:flutter/material.dart';
import 'package:drahkma/Cards/cards_flags_enum.dart';
import 'package:drahkma/Cards/cards_type_enum.dart';
import 'package:drahkma/Interfaces/dto_interface.dart';
import 'package:intl/intl.dart';

class CardsDto implements DtoInterface{
    int? _id;
    CardsTypeEnum? _type;
    String? _brand;
    CardFlagsEnum? _flag;
    DateTime? _expires_at;
    String? _last_4_digits;
    int? _invoice_day;


    CardsDto({
      int? id, 
      CardsTypeEnum? type,
      String? brand,
      String? expires_at,
      CardFlagsEnum? flag,
      int? invoice_day,
      String? last_4_digits
    }){
      setId = id;
      setBrand = brand;
      setExpires_at = expires_at.toString();
      setFlag = flag;
      setInvoice_day = invoice_day;
      setLast_4_digits = last_4_digits;
      setType = type;
    }

    set setId(int? id) => this._id = id;
    set setType(CardsTypeEnum? type) => this._type = type;
    set setBrand(String? brand) => this._brand = brand;
    set setFlag(CardFlagsEnum? flag) => this._flag = flag;
    // ignore: non_constant_identifier_names
    set setExpires_at(String? exp){

      try{
        DateTime dt = DateFormat('MM/yyyy').parse(exp!);
        _expires_at = dt;
      }catch(e){
        _expires_at = null;
      }
      
      // if(exp!.length == 4){
      //   try{
      //     this.expires_at = exp;
      //   }catch(e){
      //     expires_at = null;
      //     rethrow;
      //   }
      // }else{
      //   expires_at = null;
      // }
    }
    // ignore: non_constant_identifier_names
    set setLast_4_digits(String? lst) => _last_4_digits = lst;
    // ignore: non_constant_identifier_names
    set setInvoice_day(int? invoice){
      // var val = DateTime.parse(invoice!);
      if((invoice! > 0 && invoice < 31)){
        _invoice_day = invoice;
      }else{
        _invoice_day = null;
      }
    }


    String? get brand => _brand;
    int? get id => _id;
    CardsTypeEnum? get type => _type;
    DateTime? get expires_at => _expires_at;
    CardFlagsEnum? get flag => _flag;

    String? get last_4_digits => _last_4_digits;
    int? get invoice_day => _invoice_day;


    get nextInvoiceDate{
      DateTime date = DateTime(DateTime.now().year, DateTime.now().month, int.parse(_invoice_day.toString()));
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
  factory CardsDto.toObject(Map<String, dynamic> data) {
    String? data_brand = data['brand'] ?? "";
    int? data_id = data['id'] ?? 0;
    // setUser = data['user'] ?? 0;
    CardsTypeEnum? data_type = CardsTypeEnum.values.firstWhere((val) => val.name == data['type'].toString());
    CardFlagsEnum? data_flag = CardFlagsEnum.values.firstWhere((val) => val.name == data['flag'].toString());
    String? data_expires_at = data['expires_at'] ?? "";
    int? data_invoice_day = data['invoice_day'] ?? 1;
    String? data_last_4_digits = data['last_4_digits'] ?? "";

    return CardsDto(
      id: data_id, 
      brand: data_brand,
      type: data_type,
      flag: data_flag,
      expires_at: data_expires_at,
      invoice_day: data_invoice_day,
      last_4_digits: data_last_4_digits
    );
  }

  @override
  toMap() {
    return {
      'id' : _id,
      'type' : _type!.name,
      'brand' : _brand,
      'expires_at' : DateFormat('MMyy').format(_expires_at!),
      'flag' : _flag!.name,
      'invoice_day' : _invoice_day,
      'last_4_digits' : _last_4_digits
    };
  }
  
}

class CardsSort{
  static Comparator<CardsDto> asc = (CardsDto it1, CardsDto it2) =>  it1.brand!.compareTo(it2.brand.toString());

  static Comparator<CardsDto> desc = (CardsDto it1, CardsDto it2) => it2.brand!.compareTo(it1.brand.toString());
}