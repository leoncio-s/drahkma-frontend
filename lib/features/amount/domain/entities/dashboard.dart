import 'package:drahkma/features/amount/data/models/amount_model.dart';
import 'package:drahkma/features/amount/data/models/transfer_bank_amount_model.dart';

class Dashboard{
  double inflow = 0.0;
  double outflow = 0.0;
  double amount = 0.0;
  double totalAmountInflowTransferBank = 0.0;
  double totalAmountOutflowTransferBank=0.0;
  double totalAmountInflowCards=0.0;
  double totalAmountOutflowCards = 0.0;
  List<AmountModel>? amountInflowCategory = [];
  List<AmountModel>? amountOutflowCategory = [];
  List<AmountModel>? amountInflowCard = [];
  List<AmountModel>? amountOutflowCard = [];
  List<TransferBankAmountModel>? amountInflowTransferBank = [];
  List<TransferBankAmountModel>? amountOutflowTransferBank = [];

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
}