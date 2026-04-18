
enum CardTypeEnum{
  // ignore: constant_identifier_names
  Credit('Credito'),
  // ignore: constant_identifier_names
  Debit('Debito'),
  // ignore: constant_identifier_names
  VR('Vale Refeição'),
  // ignore: constant_identifier_names
  VA('Vale Alimentação'),
  // ignore: constant_identifier_names
  Others('Outros');

  
  const CardTypeEnum(this.type);
  
  final String type;
}