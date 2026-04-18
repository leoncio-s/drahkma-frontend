import 'dart:developer';

import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_bank.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_delete.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_get_all.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_save.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BankAccountController extends ValueNotifier<AppState> {
  final BankAccountBank _bank;
  final BankAccountGetAll _getAll;
  final BankAccountSave _save;
  final BankAccountUpdate _update;
  final BankAccountDelete _delete;
  dynamic data;

  BankAccountController(
    this._bank,
    this._getAll,
    this._save,
    this._update,
    this._delete,
  ) : super(BankAccountInitial());

  Future<void> loadBanks() async {
    value = BankAccountLoading();
    try {
      data = await _bank.call();
      value = BankAccountLoaded();
    } catch (e) {
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> loadBankAccounts() async {
    value = BankAccountLoading();
    try {
      data = await _getAll.call();
      value = BankAccountLoaded();
    } catch (e) {
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> saveBankAccount(BankAccountDTO account) async {
    try {
      data = await _save.call(dto: account);
      await loadBankAccounts();
      value = BankAccountSaved();
    } catch (e) {
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> updateBankAccount(BankAccountDTO account) async {
    try {
      await _update.call(dto: account);
      await loadBankAccounts();
      value = BankAccountSaved();
    } catch (e) {
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> deleteBankAccount(BankAccountDTO accountId) async {
    try {
      await _delete.call(dto: BankAccountMapper.fromDTOToEntity(accountId));
      await loadBankAccounts();
    } on ClientException catch (e) {
      value = AppStateError(message: e.message);
    }catch(e, s)
    {
      log(e.toString(), stackTrace: s, name: "Delete Bank Account", error: accountId);
    }
  }
}

class BankAccountInitial extends AppState {}
class BankAccountLoading extends AppState {}
class BankAccountLoaded extends AppState {}
class BankAccountSaved extends AppState {}
