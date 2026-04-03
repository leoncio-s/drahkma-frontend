import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_bank.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_delete.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_get_all.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_save.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_update.dart';
import 'package:flutter/material.dart';

class BankAccountController extends ValueNotifier<AppState> {
  final BankAccountBank _bank;
  final BankAccountGetAll _getAll;
  final BankAccountSave _save;
  final BankAccountUpdate _update;
  final BankAccountDelete _delete;

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
      await _bank.call();
      value = BankAccountLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> loadBankAccounts() async {
    value = BankAccountLoading();
    try {
      await _getAll.call();
      value = BankAccountLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> saveBankAccount(dynamic account) async {
    try {
      await _save.call(account: account);
      await loadBankAccounts();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> updateBankAccount(dynamic account) async {
    try {
      await _update.call(account: account);
      await loadBankAccounts();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> deleteBankAccount(int accountId) async {
    try {
      await _delete.call(id: accountId);
      await loadBankAccounts();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }
}

class BankAccountInitial extends AppState {}
class BankAccountLoading extends AppState {}
class BankAccountLoaded extends AppState {}
