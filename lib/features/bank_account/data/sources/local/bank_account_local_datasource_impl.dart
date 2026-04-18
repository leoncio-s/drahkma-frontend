import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/data/sources/local/bank_account_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankAccountLocalDatasourceImpl implements BankAccountLocalDatasource {
  final SharedPreferencesAsync storage;

  BankAccountLocalDatasourceImpl({required this.storage});

  @override
  Future<void> saveBankAccounts(List<BankAccount> accounts) async {
    List<Map<String, dynamic>> dtoList = accounts
        .map((account) => BankAccountMapper.fromEntityToDTO(account).toMap())
        .toList();
    await storage.setString(
        Config.keyStorageBankAccounts,
        JsonEncoder().convert(dtoList));
  }

  @override
  Future<List<BankAccount>?> getBankAccounts() async {
    String? jsonString = await storage.getString(Config.keyStorageBankAccounts);
    if (jsonString != null) {
      List<dynamic> jsonList = JsonDecoder().convert(jsonString);
      return jsonList
          .map((json) => BankAccountModel.fromJson(json))
          .cast<BankAccount>()
          .toList();
    }
    return [];
  }

  @override
  Future<void> clearBankAccounts() async {
    await storage.remove(Config.keyStorageBankAccounts);
  }
}
