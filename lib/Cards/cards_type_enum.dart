
enum CardsTypeEnum{
  credit('Credito'),
  debit('Debito'),
  vR('Vale Refeição'),
  vA('Vale Alimentação'),
  others('Outros');

  
  const CardsTypeEnum(this.type);
  
  final String type;
}