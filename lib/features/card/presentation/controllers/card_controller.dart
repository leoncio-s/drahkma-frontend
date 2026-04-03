import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/card/domain/usecases/card_delete.dart';
import 'package:drahkma/features/card/domain/usecases/card_get_all.dart';
import 'package:drahkma/features/card/domain/usecases/card_save.dart';
import 'package:drahkma/features/card/domain/usecases/card_update.dart';
import 'package:flutter/material.dart';

class CardController extends ValueNotifier<AppState> {
  final CardGetAll _getAll;
  final CardSave _save;
  final CardUpdate _update;
  final CardDelete _delete;

  CardController(this._getAll, this._save, this._update, this._delete)
      : super(CardInitial());

  Future<void> loadCards() async {
    value = CardLoading();
    try {
      await _getAll.call();
      value = CardLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> saveCard(dynamic card) async {
    try {
      await _save.call(card: card);
      await loadCards();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> updateCard(dynamic card) async {
    try {
      await _update.call(card: card);
      await loadCards();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> deleteCard(int cardId) async {
    try {
      await _delete.call(id: cardId);
      await loadCards();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }
}

class CardInitial extends AppState {}
class CardLoading extends AppState {}
class CardLoaded extends AppState {}
