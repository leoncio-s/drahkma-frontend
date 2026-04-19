import 'package:drahkma/features/amount/data/models/amount_model.dart';
import 'package:drahkma/features/amount/data/models/transfer_bank_amount_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';

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
    double totalAmountInflowTransferBank = double.tryParse(data['totalAmountInflowTransferBank'].toString())  ?? 0.00;
    double totalAmountOutflowTransferBank = double.tryParse(data['totalAmountOutflowTransferBank'].toString()) ?? 0.00;
    double totalAmountInflowCards = double.tryParse(data['totalAmountInflowCards'].toString()) ?? 0.00;
    double totalAmountOutflowCards = double.tryParse(data['totalAmountOutflowCards'].toString()) ?? 0.00;
    double inflow = double.tryParse(data['inflow'].toString()) ?? 0.00;
    double outflow = double.tryParse(data['outflow'].toString()) ?? 0.00;
    double amount = double.tryParse(data['amount'].toString()) ?? 0.00;

    List<AmountModel> amountInflowCategory =
        List.of(data['amountInflowCategory'])
            .map((el) => AmountModel.fromJson(el))
            .toList();
    List<AmountModel> amountOutflowCategory =
        List.of(data['amountOutflowCategory'])
            .map((el) => AmountModel.fromJson(el))
            .toList();

    List<AmountModel>  amountInflowCard = List.of(data['amountInflowCard'])
        .map((el) => AmountModel.fromJson(el))
        .toList();
    List<AmountModel> amountOutflowCard = List.of(data['amountOutflowCard'])
        .map((el) => AmountModel.fromJson(el))
        .toList();

    List<TransferBankAmountModel> amountInflowTransferBank =
        List.of(data['amountInflowTransferBank'])
            .map((el) => TransferBankAmountModel.fromJson(el))
            .toList();

    List<TransferBankAmountModel> amountOutflowTransferBank =
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
    return toMap().toString();
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
      'amountInflowCard': amountInflowCard?.map((e)=> e.toMap()).toList(),
      'amountInflowCategory': amountInflowCategory?.map((e)=> e.toMap()).toList(),
      'amountInflowTransferBank': amountInflowTransferBank?.map((e)=> e.toMap()).toList(),
      'amountOutflowCard': amountOutflowCard?.map((e)=> e.toMap()).toList(),
      'amountOutflowCategory': amountOutflowCategory?.map((e)=> e.toMap()).toList(),
      'amountOutflowTransferBank': amountOutflowTransferBank?.map((e)=> e.toMap()).toList()
    };
  }
}
