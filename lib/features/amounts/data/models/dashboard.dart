import 'package:drahkma/features/amounts/data/models/amount.dart';
import 'package:drahkma/features/amounts/data/models/transfer_bank_amount.dart';

class Dashboard{
  double inflow = 0.0;
  double outflow = 0.0;
  double amount = 0.0;
  double totalAmountInflowTransferBank = 0.0;
  double totalAmountOutflowTransferBank=0.0;
  double totalAmountInflowCards=0.0;
  double totalAmountOutflowCards = 0.0;
  List<Amount>? amountInflowCategory = [];
  List<Amount>? amountOutflowCategory = [];
  List<Amount>? amountInflowCard = [];
  List<Amount>? amountOutflowCard = [];
  List<TransferBankAmount>? amountInflowTransferBank = [];
  List<TransferBankAmount>? amountOutflowTransferBank = [];

  Dashboard({
      this.inflow = 0.00,
      this.outflow = 0.00,
      this.amount = 0.00,
      this.totalAmountInflowCards = 0.00,
      this.totalAmountInflowTransferBank = 0.00,
      this.totalAmountOutflowCards = 0.00,
      this.totalAmountOutflowTransferBank = 0.00,
      this.amountInflowCard,
      this.amountInflowCategory,
      this.amountInflowTransferBank, 
      this.amountOutflowCard,
      this.amountOutflowCategory,
      this.amountOutflowTransferBank
});

  factory Dashboard.fromJson(Map<String, dynamic> data){

    double totalAmountInflowTransferBank = data['totalAmountInflowTransferBank'] ?? 0.00;
    double totalAmountOutflowTransferBank= data['totalAmountOutflowTransferBank'] ?? 0.00;
    double totalAmountInflowCards= data['totalAmountInflowCards'] ?? 0.00;
    double totalAmountOutflowCards = data['totalAmountOutflowCards'] ?? 0.00;
    double inflow = data['inflow'] ?? 0.00;
    double outflow = data['outflow'] ?? 0.00;
    double amount = data['amount'] ?? 0.00;

    List<Amount>? amountInflowCategory =  List.of(data['amountInflowCategory']).map((el)=>Amount.fromJson(el)).toList();
    List<Amount>? amountOutflowCategory = List.of(data['amountOutflowCategory']).map((el)=>Amount.fromJson(el)).toList();
    List<Amount>? amountInflowCard = List.of(data['amountInflowCard']).map((el)=>Amount.fromJson(el)).toList();
    List<Amount>? amountOutflowCard = List.of(data['amountOutflowCard']).map((el)=>Amount.fromJson(el)).toList();
    
    List<TransferBankAmount>? amountInflowTransferBank = List.of(data['amountInflowTransferBank']).map((el)=>TransferBankAmount.fromJson(el)).toList();

    
    List<TransferBankAmount>? amountOutflowTransferBank = List.of(data['amountOutflowTransferBank']).map((el)=>TransferBankAmount.fromJson(el)).toList();

    return Dashboard(
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
      totalAmountOutflowTransferBank: totalAmountOutflowTransferBank
    );
  }

  @override
  String toString() {
    return {
      'inflow' : inflow,
      'outflow' : outflow,
      'amount' : amount,
      'totalAmountInflowCards' : totalAmountInflowCards,
      'totalAmountInflowTransferBank' : totalAmountInflowTransferBank,
      'totalAmountOutflowCards' : totalAmountOutflowCards,
      'totalAmountOutflowTransferBank' : totalAmountOutflowTransferBank,
      'amountInflowCard' : amountInflowCard,
      'amountInflowCategory' : amountInflowCategory,
      'amountInflowTransferBank' : amountInflowTransferBank, 
      'amountOutflowCard' : amountOutflowCard,
      'amountOutflowCategory' : amountOutflowCategory,
      'amountOutflowTransferBank' : amountOutflowTransferBank
    }.toString();
  }
}