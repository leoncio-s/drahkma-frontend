import 'package:drahkma/Tranferbank/transfer_bank_type_enum.dart';

class DashboardDto{
  double inflow = 0.0;
  double outflow = 0.0;
  double amount = 0.0;
  double totalAmountInflowTransferBank = 0.0;
  double totalAmountOutflowTransferBank=0.0;
  double totalAmountInflowCards=0.0;
  double totalAmountOutflowCards = 0.0;
  List<AmountGroupDto>? amountInflowCategory = [];
  List<AmountGroupDto>? amountOutflowCategory = [];
  List<AmountGroupDto>? amountInflowCard = [];
  List<AmountGroupDto>? amountOutflowCard = [];
  List<AmountTransferBankGroupDto>? amountInflowTransferBank = [];
  List<AmountTransferBankGroupDto>? amountOutflowTransferBank = [];

  DashboardDto({
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

  factory DashboardDto.fromJson(Map<String, dynamic> data){

    double totalAmountInflowTransferBank = data['totalAmountInflowTransferBank'] ?? 0.00;
    double totalAmountOutflowTransferBank= data['totalAmountOutflowTransferBank'] ?? 0.00;
    double totalAmountInflowCards= data['totalAmountInflowCards'] ?? 0.00;
    double totalAmountOutflowCards = data['totalAmountOutflowCards'] ?? 0.00;
    double inflow = data['inflow'] ?? 0.00;
    double outflow = data['outflow'] ?? 0.00;
    double amount = data['amount'] ?? 0.00;

    List<AmountGroupDto>? amountInflowCategory =  List.of(data['amountInflowCategory']).map((el)=>AmountGroupDto.fromJson(el)).toList();
    List<AmountGroupDto>? amountOutflowCategory = List.of(data['amountOutflowCategory']).map((el)=>AmountGroupDto.fromJson(el)).toList();
    List<AmountGroupDto>? amountInflowCard = List.of(data['amountInflowCard']).map((el)=>AmountGroupDto.fromJson(el)).toList();
    List<AmountGroupDto>? amountOutflowCard = List.of(data['amountOutflowCard']).map((el)=>AmountGroupDto.fromJson(el)).toList();
    
    List<AmountTransferBankGroupDto>? amountInflowTransferBank = List.of(data['amountInflowTransferBank']).map((el)=>AmountTransferBankGroupDto.fromJson(el)).toList();

    
    List<AmountTransferBankGroupDto>? amountOutflowTransferBank = List.of(data['amountOutflowTransferBank']).map((el)=>AmountTransferBankGroupDto.fromJson(el)).toList();

    return DashboardDto(
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
      'inflow' : this.inflow,
      'outflow' : this.outflow,
      'amount' : this.amount,
      'totalAmountInflowCards' : this.totalAmountInflowCards,
      'totalAmountInflowTransferBank' : this.totalAmountInflowTransferBank,
      'totalAmountOutflowCards' : this.totalAmountOutflowCards,
      'totalAmountOutflowTransferBank' : this.totalAmountOutflowTransferBank,
      'amountInflowCard' : this.amountInflowCard,
      'amountInflowCategory' : this.amountInflowCategory,
      'amountInflowTransferBank' : this.amountInflowTransferBank, 
      'amountOutflowCard' : this.amountOutflowCard,
      'amountOutflowCategory' : this.amountOutflowCategory,
      'amountOutflowTransferBank' : this.amountOutflowTransferBank
    }.toString();
  }
}

class AmountGroupDto{
  double? total = 0.0;
  String? description = "";
  AmountGroupDto({this.total, this.description});

  factory AmountGroupDto.fromJson(Map<String, dynamic> data){
    return AmountGroupDto(
      total: data['total'],
      description: data['description']
    );
  }

  @override
  String toString(){
    return {
      'total' : this.total,
      'description' : this.description,
    }.toString();
  }
}

class AmountTransferBankGroupDto{
  double? total = 0.0;
  String? description = "";
  TransferBankTypeEnum? type = TransferBankTypeEnum.OTHERS;

  AmountTransferBankGroupDto({this.total, this.description, this.type});

  factory AmountTransferBankGroupDto.fromJson(Map<String, dynamic> data){

    
    return AmountTransferBankGroupDto(
      total: data['total'],
      description: data['description'],
      type: TransferBankTypeEnum.values.where((el) => el.name == data['type']).first
    );
  }

  @override
  String toString() {
    return {
      'total' : this.total,
      'description' : this.description,
      'type' : this.type!.name
    }.toString();
  }
}