import 'package:drahkma/features/bank_accounts/domain/entities/bank.dart';

class BankModel extends Bank {

  BankModel({super.ispb, super.name, super.code, super.fullName});

  factory BankModel.fromJson(Map<String, dynamic> json){
    return BankModel(ispb: json['ispb'], name: json['name'], code: json['code'], fullName: json['fullName']);
  }
}