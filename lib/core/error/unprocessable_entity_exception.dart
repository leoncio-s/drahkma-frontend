import 'package:drahkma/core/data/models/unprocessable_entity_model.dart';

class UnprocessableEntityException implements Exception{
  final UnprocessableEntityModel? error;
  UnprocessableEntityException({this.error});
}