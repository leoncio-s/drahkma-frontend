enum ItemsOrderEnum {
  DataDecrescente("Data Decrescente"),
  DataAscendente("Data Ascendente"),

  DescricaoDecrescente("Descrição Decrescente"),
  DescricaoAscendente("Descrição Ascendente"),
  
  ValorDecrescente("Valor Decrescente"),
  ValorAscendente("Valor Ascendente");

  const ItemsOrderEnum(this.element);

  final String element;
}