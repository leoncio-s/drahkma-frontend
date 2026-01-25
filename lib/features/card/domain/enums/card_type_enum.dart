
enum CardTypeEnum{
  credit('Credito'),
  debit('Debito'),
  vR('Vale Refeição'),
  vA('Vale Alimentação'),
  others('Outros');

  
  const CardTypeEnum(this.type);
  
  final String type;
}