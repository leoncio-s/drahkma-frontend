import 'package:drahkma/features/cards/data/models/cards_dto.dart';
import 'package:drahkma/features/cards/data/models/cards_model.dart';
import 'package:drahkma/features/cards/data/sources/cards_remote_datasource.dart';
import 'package:drahkma/features/cards/domain/entities/cards.dart';
import 'package:drahkma/features/cards/domain/repositories/cards_repository.dart';

class CardsRepositoryImpl implements CardsRepository
{

  final CardsRemoteDatasource _datasource;
  CardsRepositoryImpl(CardsRemoteDatasource datasource): _datasource = datasource;

  @override
  Future<void> delete(Cards card) async {
    return await _datasource.delete(card as CardsModel);
  }

  @override
  Future<List<Cards>?> getAll() async {
    return await _datasource.getAll();
  }

  @override
  Future<Cards?> getBy({int? id}) async {
    return await _datasource.getBy(id:id);
  }

  @override
  Future<Cards?> save(Cards card) async {
    return await _datasource.save(card as CardsDTO);
  }

  @override
  Future<void> update(Cards card) async {
    return await _datasource.update(card as CardsDTO);
  }
  
}