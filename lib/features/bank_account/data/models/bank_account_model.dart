class BankAccountModel {
  final int? id;
  final String? bankCode;
  final String? accountNumber;
  final String? agency;
  final String? bankName;

  BankAccountModel(
      {this.id,
      this.bankCode,
      this.accountNumber,
      this.agency,
      this.bankName});

  factory BankAccountModel.fromJson(Map<String, dynamic> data) {
    int? id = data['id'] ?? 0;
    String? bankCode = data['bankCode'] ?? "";
    String? bankName = data['bankName'] ?? "";
    String? agency = data['agency'] ?? "";
    String? accountNumber = data['accountNumber'] ?? "";

    return BankAccountModel(id: id, bankCode: bankCode, bankName: bankName, agency: agency, accountNumber: accountNumber);
  }
}