import 'package:drahkma/features/card/data/models/card_dto.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/data/sources/card_remote_datasource.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/repositories/card_repository.dart';

class CardRepositoryImpl implements CardRepository
{

  final CardRemoteDatasource _datasource;
  CardRepositoryImpl(CardRemoteDatasource datasource): _datasource = datasource;

  @override
  Future<void> delete(Card card) async {
    return await _datasource.delete(card as CardModel);
  }

  @override
  Future<List<Card>?> getAll() async {
    return await _datasource.getAll();
  }

  @override
  Future<Card?> getBy({int? id}) async {
    return await _datasource.getBy(id:id);
  }

  @override
  Future<Card?> save(Card card) async {
    return await _datasource.save(card as CardDTO);
  }

  @override
  Future<void> update(Card card) async {
    return await _datasource.update(card as CardDTO);
  }
  
}