import 'dart:developer';

import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/usecases/card_delete.dart';
import 'package:drahkma/features/card/domain/usecases/card_get_all.dart';
import 'package:drahkma/features/card/domain/usecases/card_save.dart';
import 'package:drahkma/features/card/domain/usecases/card_update.dart';
import 'package:flutter/material.dart' as material;
import 'package:http/http.dart';

class CardController extends material.ValueNotifier<AppState> {
  final CardGetAll _getAll;
  final CardSave _save;
  final CardUpdate _update;
  final CardDelete _delete;

  List<Card>? data;

  CardController(this._getAll, this._save, this._update, this._delete)
      : super(CardInitial());

  Future<void> loadCards() async {
    value = CardLoading();
    try {
      data = await _getAll.call();
      value = CardLoaded();
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Load Cards");
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> saveCard(Card? card) async {
    try {
      await _save.call(dto: card);
      value = CardSaved();
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Save Card", error: card);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> updateCard(Card? card) async {
    try {
      await _update.call(dto: card);
      value = CardSaved();
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Update Card", error: card);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> deleteCard(Card card) async {
    try {
      await _delete.call(dto: card);
    }on ClientException catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Delete Card", error: card);
      value = AppStateError(message: e.message);
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Delete Card", error: card);
      value = AppStateError(message: e.toString());
    }
  }
}

class CardInitial extends AppState {}
class CardLoading extends AppState {}
class CardLoaded extends AppState {}
class CardSaved extends AppState {}
