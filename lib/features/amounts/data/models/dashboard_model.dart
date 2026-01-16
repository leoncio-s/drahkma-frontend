import 'package:drahkma/features/amounts/data/models/amount_model.dart';
import 'package:drahkma/features/amounts/data/models/transfer_bank_amount_model.dart';
import 'package:drahkma/features/amounts/domain/entities/dashboard.dart';

class DashboardModel extends Dashboard {
  DashboardModel(
      {super.inflow = 0.00,
      super.outflow = 0.00,
      super.amount = 0.00,
      super.totalAmountInflowCards = 0.00,
      super.totalAmountInflowTransferBank = 0.00,
      super.totalAmountOutflowCards = 0.00,
      super.totalAmountOutflowTransferBank = 0.00,
      super.amountInflowCard,
      super.amountInflowCategory,
      super.amountInflowTransferBank,
      super.amountOutflowCard,
      super.amountOutflowCategory,
      super.amountOutflowTransferBank});

  factory DashboardModel.fromJson(Map<String, dynamic> data) {
    double totalAmountInflowTransferBank =
        data['totalAmountInflowTransferBank'] ?? 0.00;
    double totalAmountOutflowTransferBank =
        data['totalAmountOutflowTransferBank'] ?? 0.00;
    double totalAmountInflowCards = data['totalAmountInflowCards'] ?? 0.00;
    double totalAmountOutflowCards = data['totalAmountOutflowCards'] ?? 0.00;
    double inflow = data['inflow'] ?? 0.00;
    double outflow = data['outflow'] ?? 0.00;
    double amount = data['amount'] ?? 0.00;

    List<AmountModel>? amountInflowCategory =
        List.of(data['amountInflowCategory'])
            .map((el) => AmountModel.fromJson(el))
            .toList();
    List<AmountModel>? amountOutflowCategory =
        List.of(data['amountOutflowCategory'])
            .map((el) => AmountModel.fromJson(el))
            .toList();
    List<AmountModel>? amountInflowCard = List.of(data['amountInflowCard'])
        .map((el) => AmountModel.fromJson(el))
        .toList();
    List<AmountModel>? amountOutflowCard = List.of(data['amountOutflowCard'])
        .map((el) => AmountModel.fromJson(el))
        .toList();

    List<TransferBankAmountModel>? amountInflowTransferBank =
        List.of(data['amountInflowTransferBank'])
            .map((el) => TransferBankAmountModel.fromJson(el))
            .toList();

    List<TransferBankAmountModel>? amountOutflowTransferBank =
        List.of(data['amountOutflowTransferBank'])
            .map((el) => TransferBankAmountModel.fromJson(el))
            .toList();

    return DashboardModel(
        inflow: inflow,
        outflow: outflow,
        amount: amount,
        amountInflowCard: amountInflowCard,
        amountOutflowCard: amountOutflowCard,
        amountInflowCategory: amountInflowCategory,
        amountOutflowCategory: amountOutflowCategory,
        amountInflowTransferBank: amountInflowTransferBank,
        amountOutflowTransferBank: amountOutflowTransferBank,
        totalAmountInflowCards: totalAmountInflowCards,
        totalAmountOutflowCards: totalAmountOutflowCards,
        totalAmountInflowTransferBank: totalAmountInflowTransferBank,
        totalAmountOutflowTransferBank: totalAmountOutflowTransferBank);
  }

  @override
  String toString() {
    return {
      'inflow': inflow,
      'outflow': outflow,
      'amount': amount,
      'totalAmountInflowCards': totalAmountInflowCards,
      'totalAmountInflowTransferBank': totalAmountInflowTransferBank,
      'totalAmountOutflowCards': totalAmountOutflowCards,
      'totalAmountOutflowTransferBank': totalAmountOutflowTransferBank,
      'amountInflowCard': amountInflowCard,
      'amountInflowCategory': amountInflowCategory,
      'amountInflowTransferBank': amountInflowTransferBank,
      'amountOutflowCard': amountOutflowCard,
      'amountOutflowCategory': amountOutflowCategory,
      'amountOutflowTransferBank': amountOutflowTransferBank
    }.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'inflow': inflow,
      'outflow': outflow,
      'amount': amount,
      'totalAmountInflowCards': totalAmountInflowCards,
      'totalAmountInflowTransferBank': totalAmountInflowTransferBank,
      'totalAmountOutflowCards': totalAmountOutflowCards,
      'totalAmountOutflowTransferBank': totalAmountOutflowTransferBank,
      'amountInflowCard': amountInflowCard,
      'amountInflowCategory': amountInflowCategory,
      'amountInflowTransferBank': amountInflowTransferBank,
      'amountOutflowCard': amountOutflowCard,
      'amountOutflowCategory': amountOutflowCategory,
      'amountOutflowTransferBank': amountOutflowTransferBank
    };
  }
}
