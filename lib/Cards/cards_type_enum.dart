
enum CardsTypeEnum{
  Credit('Credito'),
  Debit('Debito'),
  VR('Vale Refeição'),
  VA('Vale Alimentação'),
  Others('Outros');

  
  const CardsTypeEnum(this.type);
  
  final String type;
}