import 'package:drahkma/features/amounts/domain/entities/amount.dart';

class AmountModel extends Amount {
  AmountModel({super.total, super.description});

  factory AmountModel.fromJson(Map<String, dynamic> data) {
    return AmountModel(total: data['total'], description: data['description']);
  }

  @override
  String toString() {
    return {
      'total': total,
      'description': description,
    }.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'description': description,
    };
  }
}
