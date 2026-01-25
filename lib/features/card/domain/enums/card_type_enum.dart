
enum CardTypeEnum{
  credit('Credito'),
  debit('Debito'),
  vr('Vale Refeição'),
  va('Vale Alimentação'),
  others('Outros');

  
  const CardTypeEnum(this.type);
  
  final String type;
}