import 'dart:developer';

import 'package:drahkma/features/card/data/mappers/card_mapper.dart';
import 'package:drahkma/features/card/data/sources/remote/card_remote_datasource.dart';
import 'package:drahkma/features/card/data/sources/local/card_local_datasource.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/repositories/card_repository.dart';

class CardRepositoryImpl implements CardRepository
{
  final CardRemoteDatasource _remoteDatasource;
  final CardLocalDatasource _localDatasource;
  
  CardRepositoryImpl(CardRemoteDatasource remoteDatasource, CardLocalDatasource localDatasource)
    : _remoteDatasource = remoteDatasource,
      _localDatasource = localDatasource;

  @override
  Future<void> delete(Card card) async {
    try {
      await _remoteDatasource.delete(CardMapper.toModel(card));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Card>?> getAll() async {
    try {
      List<Card>? cards = await _remoteDatasource.getAll() as List<Card>?;
      if (cards != null) {
        await _localDatasource.saveCards(cards);
      }
      return cards;
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Repo Load Cards");
      // Fallback to local datasource on network error
      return await _localDatasource.getCards();
    }
  }

  @override
  Future<Card?> getBy({int? id}) async {
    var data = await _remoteDatasource.getBy(id:id);
    return CardMapper.toEntity(data!);
  }

  @override
  Future<Card?> save(Card card) async {
    try {
      var data = await _remoteDatasource.save(CardMapper.fromEntityToDTO(card));
      Card? savedCard = CardMapper.toEntity(data!);
      await _localDatasource.saveCards([savedCard]);
      return savedCard;
    } catch (e) {
      await _localDatasource.getCards().then((cards) => cards?.isEmpty ?? true ? null : cards?.first);
      rethrow;
    }
  }

  @override
  Future<void> update(Card card) async {
    try {
      await _remoteDatasource.update(CardMapper.fromEntityToDTO(card));
      await _localDatasource.saveCards([card]);
    } catch (e) {
      // On network error, at least save to local
      await _localDatasource.saveCards([card]);
      rethrow;
    }
  }
  
}