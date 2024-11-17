import 'package:drahkma/Interfaces/dto_interface.dart';

class BankAccountsDto implements DtoInterface {
  int? id;
  String? bankCode;
  String? bankName;
  String? agency;
  String? accountNumber;

  BankAccountsDto(
      {this.id,
      this.bankCode,
      this.accountNumber,
      this.agency,
      this.bankName});

  set Id(int? id) => this.id = id;
  set BankCode(String? bankCode) => this.bankCode = bankCode;
  set BankName(String? bankName) => this.bankName = bankName;
  set Agency(String? agency) => this.agency = agency;
  set AccountNumber(String? accountNumber) =>
      this.accountNumber = accountNumber;

  @override
  factory BankAccountsDto.toObject(Map<String, dynamic> data) {
    int? id = data['id'] ?? 0;
    String? bankCode = data['bankCode'] ?? "";
    String? bankName = data['bankName'] ?? "";
    String? agency = data['agency'] ?? "";
    String? accountNumber = data['accountNumber'] ?? "";

    return BankAccountsDto(id: id, bankCode: bankCode, bankName: bankName, agency: agency, accountNumber: accountNumber);
  }
  
  @override
  Map<String, dynamic> toMap() {
      return {
              'id' : id,
              'bankCode' : bankCode,
              'bankName' : bankName,
              'agency' : agency,
              'accountNumber' : accountNumber
      };
  }
}

class BankAccountsSort{
  static Comparator<BankAccountsDto> asc = (BankAccountsDto it1, BankAccountsDto it2) =>  it1.bankName!.compareTo(it2.bankName.toString());

  static Comparator<BankAccountsDto> desc = (BankAccountsDto it1, BankAccountsDto it2) => it2.bankName!.compareTo(it1.bankName.toString());
}
