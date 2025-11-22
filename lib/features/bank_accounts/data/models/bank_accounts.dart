
class BankAccounts{
  int? id;
  String? bankCode;
  String? bankName;
  String? agency;
  String? accountNumber;

  BankAccounts(
      {this.id,
      this.bankCode,
      this.accountNumber,
      this.agency,
      this.bankName});

  @override
  factory BankAccounts.toObject(Map<String, dynamic> data) {
    int? id = data['id'] ?? 0;
    String? bankCode = data['bankCode'] ?? "";
    String? bankName = data['bankName'] ?? "";
    String? agency = data['agency'] ?? "";
    String? accountNumber = data['accountNumber'] ?? "";

    return BankAccounts(id: id, bankCode: bankCode, bankName: bankName, agency: agency, accountNumber: accountNumber);
  }
  
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
  static Comparator<BankAccounts> asc = (BankAccounts it1, BankAccounts it2) =>  it1.bankName!.compareTo(it2.bankName.toString());

  static Comparator<BankAccounts> desc = (BankAccounts it1, BankAccounts it2) => it2.bankName!.compareTo(it1.bankName.toString());
}
